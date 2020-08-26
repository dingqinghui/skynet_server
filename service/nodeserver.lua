local skynet =  require "skynet"
require "skynet.manager"
local cluster = require "skynet.cluster"

local KEEP_LIVE_TM = 1100

local clients = {
    data = {}
}

function clients.add(nodename,addr)
    local data = clients.data
    data[nodename] = {
        nodename = nodename,
        addr = addr,
        tm = skynet.time()
    }
end

function clients.close(nodename)
    local data = clients.data
    data[nodename] = nil
end


function clients.update(nodename)
    local data = clients.data
    data[nodename].tm = skynet.time()
end

function clients.exist(nodename)
    local data = clients.data
    return data[nodename]
end

function clients.keeplive()
    local data = clients.data
    local tm = skynet.time()
    for _,v in pairs(data) do
        if tm - v.tm >= KEEP_LIVE_TM then 
            clients.close(v.nodename)
        end
    end
    skynet.timeout(500,clients.keeplive)
end



local CMD = {}
function CMD.ping(nodename,addr)
    if clients.exist(nodename) then 
        clients.update(nodename)
    else
        clients.add(nodename,addr)
    end
    return true
end


skynet.start(function ()
    skynet.dispatch("lua", function (_,_, cmd, ...)
        skynet.retpack(CMD[cmd](...))
    end)


    cluster.open(SERVERNAME)

    skynet.register(".nodeserver")

    clients.keeplive()
end )