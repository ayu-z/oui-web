local time = require 'eco.time'
local sys = require 'eco.sys'
local uci = require 'uci'

local M = {}

function M.echo(params)
    return params
end

function M.get_route()
    local c = uci.cursor()
    local users = {}
    c:foreach('n2n_v3', 'route', function(s)
        users[#users + 1] = { --数组索引值从1开始,
            ip = s.target,
            mask1 = s.mask,
            gateway = s.gateway,
            description = s.comment,
            id = s['.name']
        }
    end)

    return { users = users }
end

function M.delete_route(params)
    local c = uci.cursor()
    local id = params.id

    c:delete('n2n_v3', id)
    c:commit('n2n_v3')
end

function M.add_route(params)
    local c = uci.cursor()
    local target = params.target
    local mask = params.mask
    local gateway = params.gateway
    local comment = params.comment

    local sid = c:add('n2n_v3', 'route')
    c:set('n2n_v3', sid, 'target', target) 
    c:set('n2n_v3', sid, 'mask', mask)
    c:set('n2n_v3', sid, 'gateway', gateway)
    c:set('n2n_v3', sid, 'comment', comment) 
    c:commit('n2n_v3')
end

function M.change_route(params)
    local c = uci.cursor()
    local target = params.target
    local mask = params.mask
    local gateway = params.gateway
    local comment = params.comment
    local id = params.id

    c:set('n2n_v3', id, 'target', target)
    c:set('n2n_v3', id, 'mask', mask)
    c:set('n2n_v3', id, 'gateway', gateway)
    c:set('n2n_v3', id, 'comment', comment)
    c:commit('n2n_v3')
end

return M
