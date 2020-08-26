local skynet =  require "skynet"
require "skynet.manager"
local cluster = require "skynet.cluster"

local KEEP_LIVE_TM = 1100

local clients = {
    __data = {}
}
local self = clients

function clients.connect(nodename,addr)
    local data = self.__data
    data[nodename] = {
        nodename = nodename,
        addr = addr,
        tm = skynet.time()
    }

    skynet.error(string.format("new node client connect name:%s addr:%s",nodename,addr ))
end

function clients.disconnect(nodename)
    local data = self.__data
    data[nodename] = nil
    skynet.error(string.format("node client disconnect name:%s ",nodename ))
end


function clients.update(nodename)
    local data = self.__data
    data[nodename].tm = skynet.time()
end

function clients.exist(nodename)
    local data = self.__data
    return data[nodename]
end

function clients.keeplive()
    local data = self.__data
    local tm = skynet.time()
    for _,v in pairs(data) do
        if tm - v.tm >= KEEP_LIVE_TM then 
            self.disconnect(v.nodename)
        end
    end
    skynet.timeout(500,self.keeplive)
end



local CMD = {}
function CMD.ping(nodename,addr)
    if self.exist(nodename) then 
        self.update(nodename)
    else
        self.connect(nodename,addr)
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