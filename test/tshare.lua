local skynet = require "skynet"
local sharedata = require "skynet.sharedata"

skynet.start(function ()
    local tab = {[1] = 1,a = 100,pos =  {x = 100,y = 200}}
    sharedata.new("cfg1",tab)
    local obj = sharedata.query("cfg1")

    for k,v in pairs(obj) do
		skynet.error(string.format("nobj[%s]=%s", k,v))
    end
    -- obj.a = 1                            -- 本地代理不可以修改
    tab.a = 101
    sharedata.update("cfg1", tab)           -- 更新数据可能不会立刻生效
    skynet.sleep(1)
    --local obj1 = sharedata.query("cfg1")    
    --[[
        update后 数据在其他服务的本地代理会自动更新（有延迟） 
        代理对象是惰性的只要update后第一次使用才会更新否则会一直保存老数据内存，对于频繁更新的数据，可能导致内存过大。可以在每次更新后调用主动调用 sharedata.flush()
        如果不关心数据的热更新问题，那么可以使用sharedata.deepcopy(name, keys, ...) ，函数返回一个Lua表，访问效率更高sharedata.deepcopy("foobar", "x", "y") 会返回 foobar.x.y 的内容。
        缺点：更新时开销大
    ]] 
    for k,v in pairs(obj) do                
		skynet.error(string.format("nobj[%s]=%s", k,v))
    end

end)