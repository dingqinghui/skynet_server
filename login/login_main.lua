local skynet =  require "skynet"
local cluster = require "skynet.cluster"
require "skynet.manager"

--[[
    client 根据配置主动连接server ， 发送自己的节点名字 和 IP地址
]]

skynet.start(function ()

    
    skynet.uniqueservice("nodeclient")
    skynet.uniqueservice("nodeserver")

    skynet.error("node start success " .. SERVERNAME)
end )