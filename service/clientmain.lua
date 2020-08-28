local skynet = require "skynet"
local socket = require "skynet.socket"
local xserialize  = require "xserialize"


skynet.start(function ()
    for i=1,1000 do
        skynet.newservice("clientd")
    end

end
)
