local agentserver = require "agentserver"
local login_msg = require "login_msg"


local CMD  = {}
local handler = {}

function handler.connect()


end

function handler.disconnect()


end


function handler.commond(cmd,...)
    local f = CMD[cmd]
    if f then 
        return f(...)
    end 
end



agentserver.start(handler)