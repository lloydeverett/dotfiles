
require("oil").setup({
  win_options = {
    winbar = "%!v:lua.custom_get_oil_winbar()",
  },
})

function open_terminal_in_buffer_dir()
    local dir = vim.fn.expand("%:p:h")
    if dir:find("oil://", 1, true) == 1 then
      dir = dir:sub(#"oil://" + 1)
    end
    vim.cmd('terminal cd "' .. dir .. '" && $SHELL')
end

-- Set up nvim-cmp.
local cmp = require('cmp')

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  window = { },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' }
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  }),
  matching = { disallow_symbol_nonprefix_matching = false }
})

vim.diagnostic.config({ virtual_text = true })

-- local lspconfig = require('lspconfig')
-- lspconfig.sourcekit.setup({})

vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP Actions',
    callback = function(args)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, {noremap = true, silent = true})
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {noremap = true, silent = true})
    end,
})

local font_size = 15.5
local function update_font_size()
    vim.o.guifont = "0xProto Nerd Font Mono:h" .. font_size
end
if vim.g.neovide then
    update_font_size()
    vim.g.neovide_cursor_animation_length = 0.0
    vim.g.neovide_scroll_animation_length = 0.15
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
else
    local cinnamon = require('cinnamon')
    cinnamon.setup({})
    vim.keymap.set("n", "<C-U>", function() cinnamon.scroll("<C-U>") end)
    vim.keymap.set("n", "<C-D>", function() cinnamon.scroll("<C-D>") end)
    -- vim.keymap.set("n", "{", function()  cinnamon.scroll("{", { mode = "window" }) end)
    -- vim.keymap.set("n", "}", function() cinnamon.scroll("}", { mode = "window" }) end)
    vim.keymap.set("n", "G", function() cinnamon.scroll("G", { mode = "window", max_delta = { time = 250 } }) end)
    vim.keymap.set("n", "gg", function() cinnamon.scroll("gg", { mode = "window", max_delta = { time = 250 } }) end)
end

