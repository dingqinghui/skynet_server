local skynet = require "skynet"
require"skynet.manager"

local nodeserver 
local nodeclient

skynet.init(function ()
    nodeclient = skynet.uniqueservice("nodeclient")
    nodeserver = skynet.uniqueservice("nodeserver")
end)



local nodemgr = {}

-- 只支持cluster.call 不支持cluseter.send。send有丢失消息的风险无法嗅探是否断开连接 
function nodemgr.call(...)
    return skynet.call(nodeclient,"lua","call",...)
end


return nodemgr


