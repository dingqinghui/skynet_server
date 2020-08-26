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
            -- 只在ping中嗅探可连接/不可连接
            local ok,ret = self.call(nodename,".nodeserver","ping",nodename,addr)
            if ok then 
                self.connect(nodename)
            else
                self.disconnect(nodename)
            end
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
    -- 这里报错有可能是远程节点没有启动 或者 远程节点调用出错
    return xpcall(cluster.call,TRACEBACK,nodename,... ) 
end


local CMD = {}
function CMD.call(node,...)
    print(node,...)
    return connection.call(node,...)
end


skynet.start(function ()
    skynet.dispatch("lua", function (_,_, cmd, ...)
        skynet.retpack(CMD[cmd](...))
    end)

    read_cluster_conf()

    connection.heart()

    skynet.register(".nodeclient")
end )