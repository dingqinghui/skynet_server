local skynet = require "skynet"



skynet.start(function()
	skynet.error("Server start")
	
	local handle = skynet.uniqueservice(true,"simple")
	skynet.error("handle:",handle)

	skynet.exit()
end)