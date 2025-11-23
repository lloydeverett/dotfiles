
local default_cmd_height = 1

if os.getenv("RPI") == "1" or vim.g.neovide then
    vim.o.cmdheight = 0
else
    vim.o.cmdheight = default_cmd_height
end

vim.keymap.set('n', '<leader>;', function()
    if vim.o.cmdheight == 0 then
        vim.o.cmdheight = default_cmd_height
    else
        vim.o.cmdheight = 0
    end
end, {noremap = true, silent = true})

