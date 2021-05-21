include "config.path"


servername = "login"

preload = "./code/preload.lua"	-- run preload.lua before every lua service run
thread = 8
logger =  nil
logpath = "."

harbor = 0

start = servername .. "_main"	-- main script
bootstrap = "snlua bootstrap"	-- The service for bootstrap

console_port = 8001

cluster = "./config/loginname.lua"


luaservice = luaservice ..  "./"  .. servername .. "/?.lua;"
lua_path = lua_path ..  "./"  .. servername .. "/?.lua;"


redishost = "127.0.0.1" 
redisport = 6379


servertype = 3
serverid = 1
daemon = "./skynet.pid"
-- snax_interface_g = "snax_g"
