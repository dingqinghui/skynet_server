local skynet = require "skynet"
local msgimpl = require "msgimpl"
local msgdefine = require "msgdefine"
local dbmgr = require "dbmgr"
local rediskey = require "rediskey"
local generator = require "generator" 
local nodemgr  = require "nodemgr"

local C2L = msgdefine.C2L
local L2G = msgdefine.L2G

local function on_register(message)
	local account = message.account
	local password = message.password

	-- 检测账号密码合法性
	-- 检验账户是否存在
	local ret = dbmgr.sadd(rediskey.account_list,account)
	
	if ret == 0 then 
		skynet.error("dbmgr.sadd ret:",ret)
		return {}
	end 
	
	-- 生成UUID
	local uuid = generator.uuid()
	print(uuid)
	local info = {
		account = account,
		password = password,
		uuid = uuid
	}
	skynet.error(table.dump(info))

	ret = dbmgr.hset(rediskey.account,account,table.serialize(info))
	if ret == 0 then 
		dbmgr.srem(rediskey.account_list,account)
		return {}
	end

	return { id = L2G.REGISTER_RET,data = {result = true} }
end

local function on_login(message)
	local account = message.account
	local password = message.password

	-- 验证用户是否存在
	local ret = dbmgr.sadd(rediskey.account_list,account)
	if ret == 1 then
		skynet.error("account not exist")
		return 
	end  
	-- 验证登陆密码正确性
	ret = dbmgr.hget(rediskey.account,account)
	if not ret  then
		return 
	end  

	local info = table.unserialize(ret)
	if info.password ~= password then
		skynet.error("password not correct")
		return 
	end

	-- uuid -- token  expire
	local token = math.floor( generator.token() )
	local key = generator.keygen(rediskey.token,info.uuid)
	dbmgr.set(key,token) 
	dbmgr.expire(key,10) 


	-- get game node gate addr from control
	local ok ,addr = nodemgr.call("control",".gamemgr","balance_game")
	if not ok then 
		return 
	end
	local data = {
		result = true,
		uuid = info.uuid,
		token = token,
		gate_addr = addr,
	}

	return { id = L2G.LOGIN_RET, data = data}
end 




msgimpl.register(C2L.REGISTER_REQ,on_register)
msgimpl.register(C2L.LOGIN_REQ,on_login)