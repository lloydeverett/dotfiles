
local colorscheme = "evergarden"

local file = io.open(os.getenv("HOME") .. "/.nvimcolorscheme", "r")
if file then
    local contents = file:read("*a")
    file:close()
    colorscheme = contents:gsub("%s", "")
end

vim.cmd.colorscheme(colorscheme)

