local skynet =  require "skynet"
local cluster = require "skynet.cluster"
require "skynet.manager"

local HEART_TM = 300

local GETENV = skynet.getenv
local TRACEBACK  = debug.traceback

local clustername = {}
local function read_cluster_conf()
    local config_name = GETENV "cluster"
    local f = assert(io.open(config_name))
    local source = f:read "*a"
    f:close()
    assert(load(source, "@"..config_name, "t", clustername))()
end


local function is_route_node(nodename)
    return nodename:sub(1,2) ~= "__" and nodename ~= SERVERNAME 
end


local connection = {
    __data = {}
}

local self = connection

function connection.heart()
    for nodename,addr in pairs(clustername) do
        if is_route_node(nodename) then
            self.call(nodename,".nodeserver","ping",nodename,addr)
        end
    end
    skynet.timeout(HEART_TM,connection.heart)
end

function connection.connect(nodename)
    if self.exist(nodename) then 
        return 
    end
    self.__data[nodename]  = true
    skynet.error("new connect nodename:",nodename)
end

function connection.disconnect(nodename)
    if not self.exist(nodename) then 
        return 
    end
    self.__data[nodename] = nil
    skynet.error("dis connect nodename:",nodename)
end

function connection.exist(nodename)
    return self.__data[nodename]
end


function connection.call(nodename,...)
    local ret = xpcall(cluster.call,TRACEBACK,nodename,... ) 
    if ret then 
        self.connect(nodename)
    else
        self.disconnect(nodename)
    end
    return ret
end




skynet.start(function ()

    read_cluster_conf()

    connection.heart()

    skynet.register(".nodeclient")
end )