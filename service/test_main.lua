--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2020-08-12 11:39:10
]]

local skynet = require "skynet"
require "skynet.manager"

skynet.start(function()
	
	local maddr = skynet.self()
	------------------------------------------------通过skynet core 注册名字--------------------------------------------------
	-- -- 创建节点不会自动创建服务别名
	-- print( skynet.localname(".test") )    -- 
	-- -- 服务别名可以创建多个
	-- skynet.register(".test")
	-- print( skynet.localname(".test") )    -- 8

	-- skynet.register(".test2")
	-- print( skynet.localname(".test2") )    -- 8

	--skynet.name(name, handle)

	------------------------------------------------通过service_mgr 启动服务 注册名字--------------------------------------------------
	--[[
		create servuce  9
		first query     9
		second query    9
	]]
	-- 创建节点自动注册名字
	skynet.timeout(10,function ()  
		print( "create servuce" ,skynet.uniqueservice(true,"blank") )   -- 9
		print( "second query" ,skynet.queryservice(true, "blank") )	    -- 9
	end)

	-- 多节点全局唯一
	print("first query", skynet.queryservice(true, "blank") )	        -- 阻塞

	-----------------------------------------------------注意------------------------------------------------------
	--[[
		service_mgr 和skynet core 有不同的结构存储名字。所以在service_mgr 注册的，调用skynet core时查询不到的。
		print( skynet.localname("blank") )   -- 无输出
	]]

end)