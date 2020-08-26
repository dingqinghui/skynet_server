local skynet =  require "skynet"
local cluster = require "skynet.cluster"
require "skynet.manager"

local PING_TIME = 300

local GETENV = skynet.getenv

local clustername = {}
local function initconf()
    local config_name = GETENV "cluster"
    local f = assert(io.open(config_name))
    local source = f:read "*a"
    f:close()
    assert(load(source, "@"..config_name, "t", clustername))()
end



local lc = {}
local function connect(nodename)
    lc[nodename] = true
    skynet.error("new connect nodename:",nodename)
end

local function disconnect(nodename)
    lc[nodename] = nil
    skynet.error("dis connect nodename:",nodename)
end

local function exist(nodename)
    return lc[nodename]
end


local function call(nodename,...)
    local errfunc = function (str)
        if exist(nodename) then 
            disconnect(nodename)
        end
    end
    return xpcall(cluster.call,errfunc,nodename,... ) 
end

local function is_route_node(nodename)
    return nodename:sub(1,2) ~= "__" and nodename ~= SERVERNAME 
end


local function ping()
    for nodename,addr in pairs(clustername) do
        if is_route_node(nodename) then
            local ret  = call(nodename,".nodeserver","ping",nodename,addr)
            if ret and not exist(nodename) then 
                connect(nodename)
            end
        end
    end
    skynet.timeout(PING_TIME,ping)
end


skynet.start(function ()
    -- 读取节点配置信息
    initconf()

    ping()

    skynet.register(".nodeclient")
end )