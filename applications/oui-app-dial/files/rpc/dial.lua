local time = require 'eco.time'
local sys = require 'eco.sys'
local uci = require 'uci'
local M = {}

function M.echo(params)
    return params
end

--重启模块
function M.start()
 
end    

--重启应用
function M.reModem()
    os.execute('echo 0 > /sys/class/gpio/gpio3/value')
    time.at(3, function()
        os.execute('echo 1 > /sys/class/gpio/gpio3/value')
    end)
    
end    

return M
