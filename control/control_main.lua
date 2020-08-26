local skynet =  require "skynet"
local cluster = require "skynet.cluster"
require "skynet.manager"

local dbmgr = require "dbmgr"

local CMD = {}



skynet.start(function ()

   
    print( dbmgr.open() )
    print( dbmgr.del("C") )
    print( dbmgr.set("A", "hello") )
    print( dbmgr.sadd("C", "one") )

  


    -- 获取登陆节点信息
    -- cluster.reload

    -- node lisent
    cluster.open "control"

    skynet.error("node start success " .. SERVERNAME)
end )