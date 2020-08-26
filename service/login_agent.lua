local skynet = require "skynet"
local netpack = require "skynet.netpack"
local socket = require "skynet.socket"
--local profile = require "profile"
local queue = require "skynet.queue"
local xserialize  = require "xserialize"
local msgimpl = require "msgimpl"

local traceback = debug.traceback


local WATCHDOG
local host
local send_request

local CMD = {}
local REQUEST = {}
local client_fd

---------------------------------------
-- 用于协议的编码解码
local cs = queue()
local os_time = os.time
---------------------------------------

skynet.register_protocol {
    name = "client",
    id = skynet.PTYPE_CLIENT,	
    unpack = skynet.tostring,   --- 将C point 转换为lua 二进制字符串
}


local function send_package(pack)
	local package = string.pack(">s2", pack)
	socket.write(client_fd, package)
end

local function push_message(msgid, data)
	send_package(xserialize.encode({id = msgid,data = data}))
end

-- 发送数据
function CMD.push_message(msgid, data)
	push_message(msgid, data)
end


-- 消息分发
local function msg_dispatch(message)
	local handler = msgimpl.get(message.id)
	if not handler then 
		skynet.error("message not define callback")
		return nil
	end 
	-- 这里有待优化不是所有的消息都需要加锁来处理
	return cs(handler, message.data)
end


local function dispatch_message(session, address,data)
	-- 解包
	local message = xserialize.decode(data)

	--profile.start()
	-- 消息分发
	local ok, result = xpcall(msg_dispatch, traceback, message)
	--local time = profile.stop()
	-- if time >= 0.05 then
	-- 	skynet.error("msg spend too much time")
	-- end
	local mqlen = skynet.mqlen()
	if mqlen >= 100 then
		skynet.error("msgagent message queue length is too much,please check it.")
	end
	-- call faild
	if not ok then

	else
		if result then
			send_package( xserialize.encode(result) )
		else
			--skynet.ret(nil)
		end
	end
end

-- socket连接成功
function CMD.start(conf)
	local fd = conf.client
	local gate = conf.gate
	WATCHDOG = conf.watchdog

	client_fd = fd
	skynet.call(gate, "lua", "forward", fd)
end

-- socket断开连接
function CMD.disconnect()
	-- todo: do something before exit
	print("-- todo: do something before exit")
	skynet.exit()
end


skynet.start(function()
	-- 注册消息处理
	skynet.dispatch("lua", function(session, source, command, ...)
		local f = assert(CMD[command], "command:" .. command .. " is not exists.")
		local data = f(...)
		skynet.ret(skynet.pack(data))
	end)

	skynet.dispatch("client", function (session, address, msg)
        dispatch_message(session, address,msg)
    end)
end)

local function on_test_message(data)
	for k, v in pairs(data) do 
		skynet.error("k:",k,"value:",v)
	end 
end 

msgimpl.register(111111,on_test_message)
