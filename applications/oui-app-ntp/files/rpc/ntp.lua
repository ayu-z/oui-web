local time = require 'eco.time'
local sys = require 'eco.sys'
local uci = require 'uci'
-- uci.cursor()：创建一个新的UCI游标对象，用于对配置进行操作。
-- cursor:load(config)：加载指定名称的配置文件。
-- cursor:commit(config)：提交对配置文件所做的更改。
-- cursor:get(config, section, option)：获取指定配置文件、节和选项的值。
-- cursor:set(config, section, option, value)：设置指定配置文件、节和选项的值。
-- cursor:add(config, type)：向指定配置文件添加一个新节，并返回该节的名称。
-- cursor:delete(config, section)：从指定配置文件中删除指定节及其所有选项。
-- cursor:sections(config)：获取指定配置文件中所有节的列表。
-- cursor:get_list(“config”, “sectionname”, “option”)
local M = {}

function M.echo(params)
    return params
end


function M.deletentp(params)
    local c = uci.cursor()
    local server = params.server
    os.execute('uci del_list  system.ntp.server=' .. server .. '')
    c:commit('system')
end

function M.addntp(params)
    local c = uci.cursor()
    local server = params.server
    os.execute('uci add_list  system.ntp.server=' .. server .. '')
    c:commit('system')
end

function M.getntp()
    local c = uci.cursor()
    local users = {}
    users = c:get('system', 'ntp', 'server')
    for i,v in ipairs(users)
    do
        users[i]={
           candidate = v
        }
    end
    return { users = users }
return M
