local skynet =  require "skynet"
require "skynet.manager"
local cluster = require "skynet.cluster"
local mc = require "skynet.multicast"


local  channel
local KEEP_LIVE_TM = 12

local clients = {
    __data = {}
}
local self = clients

function clients.connect(nodename,info)
    local data = self.__data
    data[nodename] = {
        info = info,
        tm = skynet.time()
    }

    info.server_type = tonumber(info.server_type)
    info.server_id = tonumber(info.server_id)

    channel:publish("connect",nodename,info)

    skynet.error(string.format("new node client connect name:%s info:%s",nodename,table.dump(info) ))
end

function clients.disconnect(nodename)
    local data = self.__data
    local info = data[nodename]
    data[nodename] = nil

    skynet.error(string.format("node client disconnect name:%s ",nodename ))

    channel:publish("disconnect",nodename,info)
end


function clients.update(nodename,info)
    local data = self.__data
    data[nodename].tm = skynet.time()

    channel:publish("update",nodename,info)
end

function clients.exist(nodename)
    local data = self.__data
    return data[nodename]
end

function clients.keeplive()
    local data = self.__data
    local tm = skynet.time()
    for nodename,v in pairs(data) do
        if tm - v.tm >= KEEP_LIVE_TM then 
            self.disconnect(nodename)
        end
    end
    skynet.timeout(500,self.keeplive)
end



local CMD = {}
function CMD.ping(info)
    local reconnect = false
    local nodename = info.nodename
    if self.exist(nodename) then 
        self.update(nodename,info)
    else
        self.connect(nodename,info)
        reconnect = true
    end
    return true,reconnect
end

function CMD.get_channel()
    return channel.channel
end

skynet.start(function ()

    channel = mc.new()

    skynet.dispatch("lua", function (_,_, cmd, ...)
        skynet.retpack(CMD[cmd](...))
    end)


    cluster.open(SERVERNAME)

    skynet.register(".nodeserver")

    clients.keeplive()
end )