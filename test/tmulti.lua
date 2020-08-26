local skynet = require "skynet"
local multicast = require "skynet.multicast"

local type = ...
if type == "sub" then
    
    skynet.start(function()
        skynet.dispatch("lua", function (_,_, cmd, channel)
            assert(cmd == "init")
            local channel = multicast.new {
                channel = channel ,
                dispatch = function (channel, source, ...)
                    print(string.format("%s <=== %s %s",skynet.address(skynet.self()),skynet.address(source), channel), ...)
                end
            }
            channel:subscribe()

            channel:publish("aaaa","bbbb")

            channel:unsubscribe()
            
            channel:delete()
        end)
    end)
else
    skynet.start(function()
        local channel = multicast.new()
        for i=1,10 do
            local handle = skynet.newservice("tmulti","sub")
            skynet.send(handle,"lua","init",channel.channel)
        end
       
    end)
end
