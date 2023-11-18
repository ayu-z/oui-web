local time = require 'eco.time'
local sys = require 'eco.sys'
local uci = require 'uci'
local M = {}

function M.echo(params)
    return params
end

--获取/dev/目录下ttyUSBx
function M.getdev()
    local cmd = "ls /dev/ttyS*"
    local a = io.popen('' .. cmd .. '','r')
    local v = a:read("*l")
    local option = {}
    while (v)
    do
            option[ #option + 1 ] = {
                label = v,
                value = v
            }
            v = a:read("*l")
    end
    a:close()
    return {option = option }

end


--获取AT命令执行结果
function M.getresults(params)
    --at_tool "$FORM_at_comm" |tr "\r\n" " "|tr "\"" "'"
    local cmd = params.cmd --AT命令
    local c = io.popen('at_tool "$cmd" |tr "\r\n" " "|tr "\"" "'"')
end
return M
