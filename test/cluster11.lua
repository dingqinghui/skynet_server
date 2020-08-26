local skynet =  require "skynet"
local cluster = require "skynet.cluster"
require "skynet.manager"

local CMD = {}

function CMD.set(key,value)
    skynet.error("key:",key ,"value:",value)
    return 0
end 


skynet.start(function ()
    skynet.error("cluster11 start ")
    
    skynet.dispatch("lua", function(session, address, cmd, ...)
        print(session, address, cmd, ...)
        skynet.retpack(CMD[cmd](...) ) 
    end)

    cluster.reload({
        db1 = "127.0.0.1:2526",
        db2 = "127.0.0.1:2527",
    })

    cluster.open("db1")



    skynet.register(".db")

    -- 向注册cluster服务别名 其他节点通过 @服务名 远程调用
    cluster.register("db", skynet.self() )
    
    cluster.call("db2",".db2","set","name",1111 )
end )