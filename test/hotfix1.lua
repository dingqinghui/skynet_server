local skynet = require "skynet"
local cache = require "skynet.codecache"
cache.mode "OFF"	


skynet.start(function()
    -- 启动测试服务
    local addr = skynet.newservice("hotfix2")

    -- 每10S热更新一次
    while true do   
        skynet.sleep(500)
        skynet.send(addr,"lua","hotfix","hotfix2")
    end

end)


