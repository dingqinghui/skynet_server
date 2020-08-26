local skynet =  require "skynet"
local cluster = require "skynet.cluster"
require "skynet.manager"

local CMD = {}

function CMD.set(key,value)
    skynet.error("key:",key ,"value:",value)
end 



skynet.start(function ()
    skynet.error("cluster22 start ")
    
    skynet.dispatch("lua", function(session, address, cmd, ...)
        CMD[cmd](...)
    end)

    -- 加载组网配置
    cluster.reload({
        --db1 = "127.0.0.1:2526",
        db2 = "127.0.0.1:2527",
        __nowaiting = true,
    })
    -- -- 监听端口
    cluster.open("db2")
    
    skynet.register(".db2")

    -- cluster.call("db1","@db","set","name",28 )
    -- cluster.call("db1",".db","set","name",29 )

    -- local proxy = cluster.proxy("db1",".db")
    -- skynet.call(proxy,"lua","set","name",30 )

    -- local proxy = cluster.proxy("db1","@db")
    -- skynet.call(proxy,"lua","set","name",31 )

    -- local proxy = cluster.proxy("db1@db")
    -- skynet.call(proxy,"lua","set","name",32 )
end )