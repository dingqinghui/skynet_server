local skynet = require "skynet"
local reload = require "reload"
local hottest = require "hottest"
local cache = require "skynet.codecache"
cache.mode "OFF"


function print_r ( t )  
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end

local function reload_module(module_name)
    local old_module = package.loaded[module_name] or {}
    package.loaded[module_name] = nil
    --print_r(package.loaded)

    require (module_name)
    --print_r(package.loaded)
    local new_module = package.loaded[module_name]
    if type(new_module) == "table" then 
        for k, v in pairs(new_module) do
            old_module[k] = v
        end
    end

    package.loaded[module_name] = old_module
    return old_module
end


local a = hottest.a

local AAA = "11111111111111111111111"
function test_auth()
    print("--------",AAA)
end 

skynet.start(function()

    skynet.dispatch("lua", function (_,_, cmd,filename) 
            assert(cmd == "hotfix")
           
            print(filename)

            require ("hotfix2") 

            reload_module(filename)
            --print_r(hottest)
            test_auth()
    end)

    print_r(hottest)
    
end)