-- lazy.nvim bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop)["fs_stat"](lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

local function postprocess_spec(spec)
    local result = {}
    for _, v in ipairs(spec) do
        if not vim.env.NVIM_MINIMAL or v.include_in_minimal then
            table.insert(result, v)
        end
        if v.include_in_minimal ~= nil then
            v.include_in_minimal = nil
        end
    end
    return result
end

require("lazy").setup({
  spec = postprocess_spec({
      -- begin color schemes
      { 'sainnhe/gruvbox-material',
           config = function(_, _)
               vim.cmd("colorscheme gruvbox-material")
           end
      },
      { 'fxn/vim-monochrome', lazy = true },
      { 'ntk148v/komau.vim', lazy = true  },
      { 'davidosomething/vim-colors-meh', lazy = true  },
      { 'zekzekus/menguless', lazy = true  },
      { 'EdenEast/nightfox.nvim', lazy = true  },
      -- end color schemes
      { 'folke/snacks.nvim',
           opts = {
               picker = { enabled = true },
               scope = { enabled = true }
           }
      },
      { 'vimwiki/vimwiki',
           branch = 'dev',
           config = function(_, _)
               vim.g.vimwiki_list = {{
                 path = os.getenv('HOME') .. '/sync/wiki',
                 syntax = 'markdown',
                 ext = 'md'
               }}
           end
       },
      { 'stevearc/oil.nvim',
           opts = {
               win_options = {
                   winbar = "%!v:lua.get_oil_winbar()",
               },
           },
           config = function(_, opts)
               _G["" .. "get_oil_winbar"] = function()
                   local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
                   local dir = require("oil").get_current_dir(bufnr)
                   if dir then
                       return vim.fn.fnamemodify(dir, ":~")
                   else
                       return vim.api.nvim_buf_get_name(0)
                   end
               end
               require("oil").setup(opts)
           end
      },
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-lua/popup.nvim' },
      { 'nvim-telescope/telescope.nvim',
           opts = {
               defaults = {
                   path_display = { "truncate" },
               },
               extensions = { },
           },
           tag = '0.1.8'
       },
      { 'tpope/vim-fugitive' },
      { 'LukasPietzschmann/telescope-tabs' },
      { 'nvim-lualine/lualine.nvim',
           opts = {
               sections = {
                 lualine_x = {
                   { 'encoding' },
                   {
                     'fileformat',
                     symbols = {
                       unix = 'LF',
                       dos = 'CRLF',
                       mac = 'CR',
                     }
                   }
                 }
               }
           }
      },
      { 'akinsho/bufferline.nvim',
           opts = {
               options = {
                   themeable = false,
                   close_icon = '',
                   buffer_close_icon = ''
               }
           },
           config = function(_, opts)
               local bufferline = require("bufferline")
               opts.options.style_preset = bufferline.style_preset.minimal
               bufferline.setup(opts)
           end
      },
      { 'neovim/nvim-lspconfig' },
      { 'mason-org/mason.nvim',
           opts = {}
      },
      { 'mason-org/mason-lspconfig.nvim',
           opts = {}
      },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'hrsh7th/cmp-cmdline' },
      { 'hrsh7th/nvim-cmp',
           config = function(_, _)
               -- Set up nvim-cmp.
               local cmp = require('cmp')
               cmp.setup({
                   enabled = function()
                       return true
                   end,
                   snippet = {
                       expand = function(args)
                           vim.snippet.expand(args.body)
                       end,
                   },
                   window = { },
                   mapping = cmp.mapping.preset.insert({
                       ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                       ['<C-f>'] = cmp.mapping.scroll_docs(4),
                       ['<C-Space>'] = cmp.mapping.complete(),
                       ['<C-e>'] = cmp.mapping.abort(),
                       ['<Tab>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                   }),
                   sources = cmp.config.sources({
                       { name = 'nvim_lsp' },
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
           end
      },
      { 'tbabej/taskwiki' },
      { 'declancm/cinnamon.nvim',
           opts = {},
           config = function(_, opts)
               if not vim.g.neovide then
                   local cinnamon = require('cinnamon')
                   cinnamon.setup(opts)
                   vim.keymap.set("n", "<C-U>", function() cinnamon.scroll("<C-U>") end)
                   vim.keymap.set("n", "<C-D>", function() cinnamon.scroll("<C-D>") end)
                   -- vim.keymap.set("n", "{", function() cinnamon.scroll("{", { mode = "window" }) end)
                   -- vim.keymap.set("n", "}", function() cinnamon.scroll("}", { mode = "window" }) end)
                   vim.keymap.set("n", "G", function() cinnamon.scroll("G", { mode = "window", max_delta = { time = 250 } }) end)
                   vim.keymap.set("n", "gg", function() cinnamon.scroll("gg", { mode = "window", max_delta = { time = 250 } }) end)
               end
           end
      },
      { "allaman/emoji.nvim",
           dependencies = {
               "nvim-lua/plenary.nvim",
               "nvim-telescope/telescope.nvim",
           },
           opts = {
               enable_cmp_integration = false,
           },
           config = function(_, opts)
               require("emoji").setup(opts)
               -- optional for telescope integration
               local ts = require('telescope').load_extension 'emoji'
               vim.keymap.set('n', '<leader>se', ts.emoji, { desc = '[S]earch [E]moji' })
           end,
      },
      { 'rcarriga/nvim-notify',
           opts = {
               background_colour = "#000000",
               top_down = false
           }
      },
      { 'epwalsh/pomo.nvim',
           opts = {
               notifiers = {
                 {
                   name = "Default",
                   toggles = {
                       dim = false
                   },
                   opts = {
                     sticky = true,
                     title_icon = "󱎫",
                     text_icon = "󰄉",
                   },
                 },
                 { name = "System" },
               },
               sessions = {
                   pomodoro = {
                       { name = "Work", duration = "25m" },
                       { name = "Short Break", duration = "5m" },
                       { name = "Work", duration = "25m" },
                       { name = "Short Break", duration = "5m" },
                       { name = "Work", duration = "25m" },
                       { name = "Long Break", duration = "15m" },
                   },
               },
           }
      },
      { '2kabhishek/nerdy.nvim',
           dependencies = {
               'folke/snacks.nvim',
           },
           opts = {
               max_recents = 30,
               add_default_keybindings = true,
               copy_to_clipboard = false,
           },
           config = function(_, opts)
               require("nerdy").setup(opts)
               vim.keymap.set('n', '<leader>sn', "<cmd>Nerdy<CR>")
           end,
      },
      { "ThePrimeagen/harpoon",
           branch = "harpoon2",
           dependencies = { "nvim-lua/plenary.nvim" }
      },
      { 'MunifTanjim/nui.nvim',
           include_in_minimal = true,
           opts = {},
           config = function(_, opts)
               local harpoon = require("harpoon")
               harpoon:setup(opts)
               vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
               vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
               vim.keymap.set("n", "<C-1>", function() harpoon:list():select(1) end)
               vim.keymap.set("n", "<C-2>", function() harpoon:list():select(2) end)
               vim.keymap.set("n", "<C-3>", function() harpoon:list():select(3) end)
               vim.keymap.set("n", "<C-4>", function() harpoon:list():select(4) end)
               vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
               vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)
           end
      },
      { dir = "~/treectl",
           opts = {},
           dependencies = { 'MunifTanjim/nui.nvim' },
           include_in_minimal = true
      }
  }),
  install = { colorscheme = { "habamax" } },
  checker = { enabled = false }
})

