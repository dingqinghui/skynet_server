local skynet = require "skynet"
local socket = require "skynet.socket"
local xserialize  = require "xserialize"



local function send_pack(client_fd,pack)
    local package = string.pack(">s2", pack)
	socket.write(client_fd, package)
end


local function send_data(fd)
    while true do 
        local data  = xserialize.encode(
         {
            id = 10000,
            data = {
                account = "dingqinghui",
                password  = "dqh19930227"
            }
        })
        
        send_pack(fd,data)
        skynet.sleep(100)
    end
end
skynet.start(function ()
    local fd = socket.open("0.0.0.0", 17000)
    skynet.fork(send_data,fd)
end
)
