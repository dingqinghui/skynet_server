
local function reload_module(module_name)
    local old_module = package.loaded[module_name] or {}
    package.loaded[module_name] = nil
    --print_r(package.loaded)
    require (module_name)
    --print_r(package.loaded)
    local new_module = package.loaded[module_name]
    for k, v in pairs(new_module) do
        old_module[k] = v
    end

    package.loaded[module_name] = old_module
    return old_module
end


return reload_module