vim.g.vimwiki_list = {{
  path = os.getenv('HOME') .. '/sync/wiki',
  syntax = 'markdown',
  ext = 'md'
}}

require("gruvbox").setup({
  terminal_colors = true, -- add neovim terminal colors
  undercurl = true,
  underline = true,
  bold = true,
  italic = {
    strings = true,
    emphasis = true,
    comments = true,
    operators = false,
    folds = true,
  },
  strikethrough = true,
  invert_selection = false,
  invert_signs = false,
  invert_tabline = false,
  inverse = true, -- invert background for search, diffs, statuslines and errors
  contrast = "", -- can be "hard", "soft" or empty string
  palette_overrides = {},
  overrides = {},
  dim_inactive = false,
  transparent_mode = false,
})

function _G.get_oil_winbar()
  local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
  local dir = require("oil").get_current_dir(bufnr)
  if dir then
    return vim.fn.fnamemodify(dir, ":~")
  else
    return vim.api.nvim_buf_get_name(0)
  end
end

require("oil").setup({
  win_options = {
    winbar = "%!v:lua.get_oil_winbar()",
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
local cmp = require'cmp'

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
      -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)

      -- For `mini.snippets` users:
      -- local insert = MiniSnippets.config.expand.insert or MiniSnippets.default_insert
      -- insert({ body = args.body }) -- Insert at cursor
      -- cmp.resubscribe({ "TextChangedI", "TextChangedP" })
      -- require("cmp.config").set_onetime({ sources = {} })
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' }, -- For vsnip users.
    -- { name = 'luasnip' }, -- For luasnip users.
    -- { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
  }, {
    { name = 'buffer' },
  })
})

-- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
-- Set configuration for specific filetype.
--[[ cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'git' },
  }, {
    { name = 'buffer' },
  })
)
equire("cmp_git").setup() ]]--

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

local telescope = require("telescope")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
telescope.setup({
  defaults = {
    path_display = { "truncate" },
  },
  extensions = {
    zoxide = {},
  },
})
telescope.load_extension("zoxide")
vim.keymap.set("n", "<leader>e", function()
  telescope.extensions.zoxide.list({
    previewer = false,
    attach_mappings = function(prompt_bufnr, map)
      local open_with_oil = function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        if selection and selection.value then
          -- Open the selected directory with :e (or :Oil)
          vim.cmd("e " .. vim.fn.fnameescape(selection.value))
          -- Or if you want to use Oil plugin instead, use:
          -- vim.cmd("Oil " .. vim.fn.fnameescape(selection.value))
        end
      end
      -- Replace default select action with open_with_oil
      map("i", "<CR>", open_with_oil)
      map("n", "<CR>", open_with_oil)
      return true
    end,
  })
end, { noremap = true, silent = true })

vim.diagnostic.config({ virtual_text = true })

local lspconfig = require('lspconfig')
lspconfig.sourcekit.setup({})
vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP Actions',
    callback = function(args)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, {noremap = true, silent = true})
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {noremap = true, silent = true})
    end,
})

require("mason").setup()

require("mason-lspconfig").setup()

local font_size = 16.5
function update_font_size()
  vim.o.guifont = "0xProto:h" .. font_size
end
if vim.g.neovide then
  update_font_size()
  vim.o.guifont = "0xProto:h17"
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
  vim.keymap.set("n", "{", function()  cinnamon.scroll("{", { mode = "window" }) end)
  vim.keymap.set("n", "}", function() cinnamon.scroll("}", { mode = "window" }) end)
  vim.keymap.set("n", "G", function() cinnamon.scroll("G", { mode = "window", max_delta = { time = 250 } }) end)
  vim.keymap.set("n", "gg", function() cinnamon.scroll("gg", { mode = "window", max_delta = { time = 250 } }) end)
end

require("aerial").setup({
  -- optionally use on_attach to set keymaps when aerial has attached to a buffer
  on_attach = function(bufnr)
    -- Jump forwards/backwards with '{' and '}'
    vim.keymap.set("n", "[[", "<cmd>AerialPrev<CR>", { buffer = bufnr })
    vim.keymap.set("n", "]]", "<cmd>AerialNext<CR>", { buffer = bufnr })
  end,
})
-- You probably also want to set a keymap to toggle aerial

vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>")

