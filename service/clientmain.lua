local skynet = require "skynet"
local socket = require "skynet.socket"
local xserialize  = require "xserialize"


skynet.start(function ()
    for i=1,10 do
        skynet.newservice("clientd",i)
    end

end
)
