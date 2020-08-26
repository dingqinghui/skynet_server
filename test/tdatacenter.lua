local skynet = require "skynet"
local datacenter = require "skynet.datacenter"


--[[
    概述：跨节点数据共享

    datacenter.set  设置数据  最后一个参数为值  前面为节点名
    datacenter.get  获取数据  最后一个参数为值  前面为节点名
    datacenter.wait 同get  节点为nil时阻塞等待设置完成

    原理：master节点启动datacenter服务, 数据保存为树结构，get set 向主节点datacenter服务进行操作。
    缺点：所有的datacenter操作都会向master节点请求，增加了master的负担。 不支持cluster 需要自己实现。
]]

skynet.start(function()

    
    
    datacenter.set("database1","player","a","b",1)
    --database1
        --player
            --a
                --b = 1

    datacenter.set("database1","player2",1)

    local ret  = nil
    print("get node player:",datacenter.get("database1","player","a","b"))

    ret = datacenter.get("database1")
    print("get databse1:")
    for k,v in pairs(ret) do
        print("key:",k,"value",v)
    end

end )