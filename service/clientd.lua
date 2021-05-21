local skynet = require "skynet"
local socket = require "skynet.socket"
local xserialize  = require "xserialize"

local index = ...

local account = "dingqinghuis" .. index
local password = "dqh19930227" .. index

local fd
local function send_pack(client_fd,pack)
    local package = string.pack(">s2", pack)
	socket.write(client_fd, package)
end


local function register()
    local data  = xserialize.encode(
        {
           id = 10000,
           data = {
               account = account,
               password  = password
           }
       })
       
       send_pack(fd,data)
end


local function login()
    local data  = xserialize.encode(
        {
           id = 10001,
           data = {
                account = account,
                password  = password
           }
       })
       
       send_pack(fd,data)
end


local function run(fd)
    while true do 
        register()
        login()

        skynet.exit()
        skynet.sleep(500)
    end
end

local function read_pack()
    while true do 
        local msg = socket.read(fd)
        table.dump( xserialize.decode(msg) )
    end 
end 

skynet.start(function ()
    fd = socket.open("0.0.0.0", 17000)
    skynet.fork(run,fd)
    skynet.fork(read_pack)
end
)
