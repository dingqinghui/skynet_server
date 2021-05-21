local skynet =  require "skynet"
local cluster = require "skynet.cluster"
require "skynet.manager"

local GETENV = skynet.getenv

skynet.start(function ()

	skynet.fork(function () 
		skynet.traceproto("lua", true)
		skynet.trace("开始打印堆栈",1)
		print("222222",skynet.tracetag())
		local addr = skynet.newservice("gameagent")
		skynet.send(addr,"lua","connect")
	end )

end )