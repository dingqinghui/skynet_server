local skynet = require "skynet"
local msgimpl = require "msgimpl"
local msgdefine = require "msgdefine"
local dbmgr = require "dbmgr"
local rediskey = require "rediskey"

local C2L = msgdefine.C2L
local L2G = msgdefine.L2G

local function on_register(message)
	local account = message.account
	local password = message.password

	-- 检测账号密码合法性
	-- 检验账户是否存在
	local ret = dbmgr.sadd(rediskey.account_list,account)
	if ret == 0 then 
		--skynet.error("account exist")
		return 
	end 
	ret = dbmgr.hset(rediskey.account,account,password)
	if ret == 0 then 
		dbmgr.srem(rediskey.account_list,account)
		return 
	end
	return { id = L2G.REGISTER_RET,data = {result = true} }
end

local function on_login(message)
	local account = message.account
	local password = message.password

	-- 验证用户是否存在
	-- 验证登陆密码正确性
	-- 生成tocken 分配一个game

end 




msgimpl.register(C2L.REGISTER_REQ,on_register)
msgimpl.register(C2L.LOGIN_REQ,on_login)