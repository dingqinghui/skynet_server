local skynet =  require "skynet"
local cluster = require "skynet.cluster"
require "skynet.manager"


skynet.start(function ()
    -- 获取登陆节点信息
    -- cluster.reload

    -- node lisent
    cluster.open "control"

    skynet.error("node start success " .. SERVERNAME)

end )