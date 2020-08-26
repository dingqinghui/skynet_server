local skynet =  require "skynet"
local cluster = require "skynet.cluster"
require "skynet.manager"

local nodemgr = require"nodemgr"

--[[
    client 根据配置主动连接server ， 发送自己的节点名字 和 IP地址
]]

skynet.start(function ()

    
    local ok,ret = nodemgr.call("control",".nodeserver","set","111","22222222222")
    print("1111111111",ok,ret)
    skynet.error("node start success " .. SERVERNAME)
end )