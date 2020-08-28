

function table.dump(obj,deep)
    deep = deep or 1
    local out = ""  
    local t = type(obj)  
    if t == "number" then  
        out = out .. obj
    elseif t == "string" then  
        out = out .. string.format("\"%s\"",obj)
    elseif t == "table" then  
        out = out .. "\n" .. string.rep("\t", deep - 1) .. "{\n"  
        for k, v in pairs(obj) do  
            out = out .. string.rep("\t", deep) .. "[" .. table.dump(k ,deep + 1) .. "]=" .. table.dump(v,deep + 1) .. ",\n"  
        end  
        out = out .. string.rep("\t", deep - 1) .. "}"  
    elseif t == "nil" then  
        return nil  
    elseif t == "function" 
        or t == "userdata"
        or t == "thread" then 
        out = out .. tostring(obj)
    end  

    return out  
end