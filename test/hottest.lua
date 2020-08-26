
local M = {}


local A = 5

M.a = 2
M.tab = {
    a =  2,
    b =  3
}


function M.func()
    print("local vari A:",A)

    print("local vari B:",A)
end 

M.func()

return M