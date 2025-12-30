
local hostname = (function()
    local error_message = "Failed to obtain hostname for OSC parsing."
    local shell = os.getenv("SHELL")
    local handle = io.popen(shell .. " -i -c 'echo $HOST'")
    if handle == nil then
        vim.notify(error_message)
        return nil
    end
    local output = handle:read("*a"):gsub("%s", "")
    if output == "" then
        vim.notify(error_message)
        return nil
    end
    handle:close()
    return output
end)()

-- let cwd follow wherever our buffer is
vim.cmd('set autochdir')

-- sync vim cwd with terminal cwd
vim.api.nvim_create_autocmd({ 'TermRequest' }, {
    desc = 'Handles OSC 7 dir change requests',
    callback = function(ev)
        if hostname == nil then
            return
        end
        local find_pattern = "file://" .. hostname .. "/"
        local index = ev.data.sequence:find(find_pattern, 1, true)
        if not index then
            return
        end
        local cwd = '/' .. ev.data.sequence:sub(index + #find_pattern)
        if not cwd then
            return
        end
        vim.api.nvim_set_current_dir(cwd)
    end,
})
--  NOTE: the above requires the following in .zshrc:
--            function print_osc7() {
--                printf '\033]7;file://%s%s\033\\' "$HOST" "$PWD"
--            }
--            precmd_functions+=(print_osc7)
--            export HOST="$HOST"
--        or in .bashrc:
--            function print_osc7() {
--                printf '\033]7;file://%s%s\033\\' "$HOST" "$PWD"
--            }
--            PROMPT_COMMAND='print_osc7'
--            export HOST="$HOST"

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
    _G["" .. "MiniFiles"].open()
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

