
-- let cwd follow wherever our buffer is
vim.cmd('set autochdir')

-- sync vim cwd with terminal cwd
vim.api.nvim_create_autocmd({ 'TermRequest' }, {
    desc = 'Handles OSC 7 dir change requests',
    callback = function(ev)
        local cwd = ev.data.sequence:sub(ev.data.sequence:find("file://") + #"file://")
        if cwd then
            vim.api.nvim_set_current_dir(cwd)
        end
    end,
})
--  NOTE: the above requires the following in .zshrc:
--            function print_osc7() {
--                printf '\033]7;file://%s\033\\' "$PWD"
--            }
--            precmd_functions+=(print_osc7)
--        or in .bashrc:
--            function print_osc7() {
--                printf '\033]7;file://%s\033\\' "$PWD"
--            }
--            PROMPT_COMMAND='print_osc7'

local index = 1

local function open_terminal()
    local cwd = vim.fn.getcwd()
    vim.cmd('terminal $SHELL')
    vim.api.nvim_buf_set_name(0, "term" .. index .. "://" .. cwd)
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
    open_terminal()
    vim.cmd("startinsert")
end)
set_keymap("_", function()
    open_split()
end)
set_keymap("+", function()
    open_split()
    open_terminal()
    vim.cmd("startinsert")
end)

