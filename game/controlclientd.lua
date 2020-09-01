local skynet = require "skynet"
local nodemgr = require "nodemgr"
local mc = require "skynet.multicast"

local watchdog = ...

local channel

local CHANNEL_CMD = {}

local function init_channel()
    local channel_id = nodemgr.get_client_channel()
    local channel = mc.new {
        channel = channel_id ,
        dispatch = function (channel, source, cmd,...)
            local f = CHANNEL_CMD[cmd]
            if f then 
                f(...)
            end
        end
    }
    channel:subscribe()
end

local function get_agent_cnt()
    return skynet.call(watchdog,"lua","get_agent_cnt")
end

local function update_cnt()
    local cnt = get_agent_cnt()
    nodemgr.call("control",".gamemgr","update_agent_cnt",SERVERNAME,cnt)
end

function CHANNEL_CMD.connect(nodename)
    -- send gameagent count to control
    update_cnt()
    -- send gate addr to control
    local addr = skynet.call(watchdog,"lua","get_gate_addr")
    nodemgr.call("control",".gamemgr","gate_addr",SERVERNAME,addr)
end

function CHANNEL_CMD.disconnect(nodename)

end

function CHANNEL_CMD.reconnect(nodename)
    update_cnt()
end


local CMD = {}
function CMD.update_cnt()
    update_cnt()
end


skynet.start(function()
    skynet.dispatch("lua", function (_,_, cmd, ...)
        skynet.retpack(CMD[cmd](...))
    end)

    init_channel()

    skynet.register(".control")
end)