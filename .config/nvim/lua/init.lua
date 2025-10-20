
-- LSP setup
vim.diagnostic.config({ virtual_text = true })
vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP Actions',
    callback = function(_)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, {noremap = true, silent = true})
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {noremap = true, silent = true})
    end,
})

-- Neovide
local default_cmd_height = 1
vim.o.cmdheight = default_cmd_height
local font_size = 16
local font_name = "CaskaydiaMono Nerd Font Mono" -- alt: "0xProto Nerd Font Mono"
local function update_font_size()
    vim.o.guifont = font_name .. ":h" .. font_size
end
if vim.g.neovide then
    local padding_x = 18
    update_font_size()
    vim.g.neovide_cursor_animation_length = 0.0
    vim.g.neovide_scroll_animation_length = 0.15
    vim.g.neovide_padding_top = 0
    vim.g.neovide_padding_bottom = 6
    vim.g.neovide_padding_left = padding_x
    vim.g.neovide_padding_right = padding_x
    vim.g.neovide_opacity = 0.9
    vim.g.neovide_window_blurred = true
    vim.o.cmdheight = 0
    vim.keymap.set('n', ';', function()
        if vim.o.cmdheight == 0 then
            vim.o.cmdheight = default_cmd_height
        else
            vim.o.cmdheight = 0
        end
    end, {noremap = true, silent = true})
    vim.keymap.set('v', '<D-c>', '"+y')             -- copy
    vim.keymap.set('n', '<D-v>', '"+p')             -- paste normal mode
    vim.keymap.set('v', '<D-v>', '"+p')             -- paste visual mode
    vim.keymap.set('c', '<D-v>', '<C-R>+')          -- paste command mode
    vim.keymap.set('t', '<D-v>', '<C-\\><C-n>"+pi') -- paste terminal mode
    vim.keymap.set('i', '<D-v>', '<Esc>"+pi')       -- paste insert mode
    vim.keymap.set('n', '<D-->', function()         -- zoom out
        font_size = font_size - 1
        update_font_size()
    end, { noremap = true, silent = true })
    vim.keymap.set('n', '<D-=>', function()         -- zoom in
        font_size = font_size + 1
        update_font_size()
    end, { noremap = true, silent = true })
end

