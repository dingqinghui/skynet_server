local skynet =  require "skynet"
local cluster = require "skynet.cluster"
require "skynet.manager"



local CMD = {}



skynet.start(function ()

    skynet.uniqueservice("nodeclient")
    skynet.uniqueservice("nodeserver")

    skynet.error("node start success " .. SERVERNAME)
end )