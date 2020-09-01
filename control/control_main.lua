local skynet =  require "skynet"
local cluster = require "skynet.cluster"
require "skynet.manager"
require"nodemgr"


local CMD = {}



skynet.start(function ()
    skynet.uniqueservice("gamemgrd")

    skynet.error("node start success " .. SERVERNAME)
end )