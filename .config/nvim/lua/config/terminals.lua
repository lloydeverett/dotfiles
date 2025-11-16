
local index = 1

local function open_terminal_in_buffer_dir()
    local dir = vim.fn.expand("%:p:h")
    if dir:find("oil://", 1, true) == 1 then
        dir = dir:sub(#"oil://" + 1)
    end
    vim.cmd('terminal cd "' .. dir .. '" && $SHELL')
    vim.api.nvim_buf_set_name(0, "term" .. index .. "://" .. dir)
    index = index + 1
end

local function open_split()
    vim.cmd("split")
    vim.cmd("wincmd j")
    vim.api.nvim_win_set_height(0, 20)
end

local function set_keymap(key, fn)
    vim.keymap.set('n', key, fn, { noremap = true, silent = true })
    vim.keymap.set('n', "<leader>" .. key, fn, { noremap = true, silent = true })
end

set_keymap("-", function()
    _G["" .. "MiniFiles"].open(vim.api.nvim_buf_get_name(0))
end)
set_keymap("=", function()
    open_terminal_in_buffer_dir()
    vim.cmd("startinsert")
end)
set_keymap("_", function()
    open_split()
    _G["" .. "MiniFiles"].open(vim.api.nvim_buf_get_name(0))
end)
set_keymap("+", function()
    open_split()
    open_terminal_in_buffer_dir()
    vim.cmd("startinsert")
end)

