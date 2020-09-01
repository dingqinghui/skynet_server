local skynet = require "skynet"
local nodemgr = require "nodemgr"
local mc = require "skynet.multicast"
local comdefine = require"comdefine"

local SERVER_TYPE = comdefine.SERVER_TYPE

local gamelist = {}

local channel

local CHANNEL_CMD = {}

local function init_channel()
    local channel_id = nodemgr.get_server_channel()
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

function CHANNEL_CMD.connect(nodename,info)
    skynet.error("CHANNEL_CMD.connect")
    if info.server_type == SERVER_TYPE.GAME then
        info.cnt = 0
        gamelist[info.nodename] = info
    end
end

function CHANNEL_CMD.disconnect(nodename,info)
    skynet.error("CHANNEL_CMD.disconnect")
    if info.server_type == SERVER_TYPE.GAME then
        gamelist[info.nodename] = nil
    end
end



local CMD = {}
function CMD.update_agent_cnt(nodename,cnt)
    skynet.error("CHANNEL_CMD.update_agent_cnt nodename",nodename)
    local info = gamelist[nodename]
    if info then
        info.cnt = cnt
    end
    skynet.error(table.dump(gamelist))
    return true
end

function CMD.gate_addr(nodename,gate_addr)
    local info = gamelist[nodename]
    if info and info.server_type == SERVER_TYPE.GAME then
        info.gate_addr = gate_addr
    end
    return true 
end

function CMD.balance_game()
    local min
    for nn ,info in pairs(gamelist) do
        if min == nil or min.cnt > info.cnt then 
            min = info 
        end 
    end
    skynet.error(table.dump(min))

    return min and min.gate_addr or ""
end

skynet.start(function()
    skynet.dispatch("lua", function (_,_, cmd, ...)
        skynet.retpack(CMD[cmd](...))
    end)

    init_channel()

    skynet.register(".gamemgr")
end)