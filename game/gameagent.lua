local skynet = require "skynet"
local agentserver = require "agentserver"
--local login_msg = require "login_msg"


local CMD  = {}
local handler = {}


local function update_agent_cnt()
    skynet.call(".control","lua","update_cnt")
end

function handler.connect()
    update_agent_cnt()

end

function handler.disconnect()
    update_agent_cnt()

end


function handler.commond(cmd,...)
    local f = CMD[cmd]
    if f then 
        return f(...)
    end 
end



agentserver.start(handler)