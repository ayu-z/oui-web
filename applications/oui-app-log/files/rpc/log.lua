local time = require 'eco.time'
local sys = require 'eco.sys'
local uci = require 'uci'
local M = {}

function M.echo(params)
    return params
end

function M.getlog(params)
    local cmd = "dmesg"
    local a = io.popen('' .. cmd .. '','r')
    local v
    v = a:read("*a")
    a:close()
    return v
end


return M
