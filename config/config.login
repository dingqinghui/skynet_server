include "config.path"

-- preload = "./examples/preload.lua"	-- run preload.lua before every lua service run
thread = 8
logger = nil
logpath = "."
harbor = 0
start = "login_main"	-- main script
bootstrap = "snlua bootstrap"	-- The service for bootstrap
-- snax_interface_g = "snax_g"
cpath = root.."cservice/?.so"
-- daemon = "./skynet.pid"

address = "127.0.0.1"
port = 17000
