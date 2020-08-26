local skynet = require "skynet"

local GETENV = skynet.getenv

skynet.start(function()
	-- 守护进程模式无法开启console
	if GETENV("daemon") == nil then
		skynet.newservice("console")
	end
	skynet.newservice("debug_console", GETENV("console_port") or 8001)
	

	local watchdog = skynet.newservice("watchdog","login_agent" )
	local conf={
		address = GETENV("address"),
		port = GETENV("port"),
		maxclient = GETENV("maxclient"),
		nodelay = GETENV("nodelay"),
	}
	skynet.call(watchdog, "lua", "start", conf)


	skynet.exit()
end) 