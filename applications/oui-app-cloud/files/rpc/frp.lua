local time = require 'eco.time'
local sys = require 'eco.sys'
local uci = require 'uci'

local M = {}

function M.echo(params)
    return params
end

--执行frp启动脚本
function M.start(params)
    local c = uci.cursor()
    local enable = params.enable
    local server = params.server
    local port = params.port
    local mytime = params.time
    local token = params.token
    if enable then
        enable=1
    else
        enable=0
    end

    if server=="" then
        server="10.10.10.10"
    end

    if port=="" then
        port="7000"
    end

    if mytime=="" then
        mytime="40"
    end

   if token=="" then
        token="123456"
    end

    c:set('frp','common', 'enabled', enable)
    c:set('frp', 'common', 'server_port', port)
    c:set('frp', 'common', 'time', mytime)
    c:set('frp', 'common', 'token', token)
    c:set('frp', 'common', 'server_addr', server)

    c:commit('frp')
    time.at(0.5, function()
        os.execute('/etc/init.d/frp restart  2>/dev/null  1>/dev/null')
    end)
end


--获取规则
function M.get_rules()
    local c = uci.cursor()
    local users = {}
    c:foreach('frp', 'proxy', function(s)
        users[#users + 1] = { --数组索引值从1开始,
            servername = s.remark,
            type = s.type,
            remoteport = s.remote_port,
            addr = s.local_ip,
            port = s.local_port,
            domain = s.custom_domains,
            id = s['.name']
        }
    end)

    return { users = users }
end


--删除规则
function M.delete_rules(params)
    local c = uci.cursor()
    local id = params.id

    c:delete('frp', id)
    c:commit('frp')
end

--添加规则
function M.add_rules(params)
    local c = uci.cursor()
    local remark = params.remark
    local mytype = params.mytype
    local local_ip = params.local_ip
    local local_port = params.local_port
    local custom_domains = params.custom_domains
    local remote_port = params.remote_port

    local exist = false

    --确定服务名称唯一
    c:foreach('frp', 'proxy', function(s)
        if s.remark == remark then
            exist = true
            return false
        end
    end)

    if exist then
        return { code = 1, errors = 'already exist' }
    end

    local sid = c:add('frp', 'proxy')
    c:set('frp', sid, 'remark', remark) 
    c:set('frp', sid, 'type', mytype)
    c:set('frp', sid, 'remote_port', remote_port)
    c:set('frp', sid, 'local_ip', local_ip) 
    c:set('frp', sid, 'local_port', local_port)
    c:set('frp', sid, 'custom_domains', custom_domains)
    c:commit('frp')

    return { code = 0 }
end



--修改规则
function M.change_rules(params)
    local c = uci.cursor()
    local remark = params.remark
    local mytype = params.mytype
    local local_ip = params.local_ip
    local local_port = params.local_port
    local custom_domains = params.custom_domains
    local remote_port = params.remote_port
    local id = params.id

    c:set('frp', id, 'remark', remark)
    c:set('frp', id, 'type', mytype)
    c:set('frp', id, 'local_ip', local_ip)
    c:set('frp', id, 'local_port', local_port)
    if mytype=="tcp" then
        c:set('frp', id, 'remote_port', remote_port)
    else
        c:set('frp', id, 'custom_domains', custom_domains)
    end
   
    c:commit('frp')
end


return M
