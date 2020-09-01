local skynet =  require "skynet"
local cluster = require "skynet.cluster"
require "skynet.manager"

local GETENV = skynet.getenv

skynet.start(function ()

    -- 守护进程模式无法开启console
	if GETENV("daemon") == nil then
		skynet.newservice("console")
	end
	skynet.newservice("debug_console", GETENV("console_port") or 8002)
	

	local watchdog = skynet.newservice("watchdog","gameagent" )
	local conf={
		address = GETENV("address") or "127.0.0.1",
		port = GETENV("port") or 18000,
		maxclient = GETENV("maxclient") or 65535,
		nodelay = GETENV("nodelay") or true,
	}
	skynet.call(watchdog, "lua", "start", conf)

	--require"nodemgr"

	skynet.uniqueservice("controlclientd",watchdog)

    skynet.exit()
    
end )