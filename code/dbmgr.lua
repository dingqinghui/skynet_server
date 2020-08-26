local skynet = require "skynet"


local dbservice

local dbmgr =  setmetatable({}, {__index = function(tab,key)
    local f = function (...)
        return skynet.call(dbservice,"lua",key,...)
    end
    return f
end}) 


function dbmgr.open()
    dbservice = skynet.localname(".redis")

    if  not dbservice then 
        dbservice = skynet.newservice("redisd")
    end

end

return dbmgr

