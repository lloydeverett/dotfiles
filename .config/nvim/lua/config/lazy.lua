-- lazy.nvim bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
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

function _G.custom_get_oil_winbar()
    local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
    local dir = require("oil").get_current_dir(bufnr)
    if dir then
        return vim.fn.fnamemodify(dir, ":~")
    else
        return vim.api.nvim_buf_get_name(0)
    end
end

require("lazy").setup({
  spec = {
      -- begin color schemes
      { 'ellisonleao/gruvbox.nvim',
           opts = {
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
           }
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
           config = function(_, opts)
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
                   winbar = "%!v:lua.custom_get_oil_winbar()",
               },
           }
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
      { 'vim-airline/vim-airline' },
      { 'vim-airline/vim-airline-themes' },
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
      { 'hrsh7th/nvim-cmp' },
      { 'hrsh7th/cmp-vsnip' },
      { 'hrsh7th/vim-vsnip' },
      { 'tbabej/taskwiki' },
      { 'declancm/cinnamon.nvim' },
      { 'MunifTanjim/nui.nvim' },
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
      -- { 'godlygeek/tabular' },
      -- { 'preservim/vim-markdown' },
      -- { 'akinsho/toggleterm.nvim" },
      -- { 'powerman/vim-plugin-AnsiEsc' },
      -- { 'preservim/nerdtree' },
      -- { 'jvgrootveld/telescope-zoxide',
      --      dependencies = {
      --          "nvim-telescope/telescope.nvim",
      --      }
      -- },
  },
  install = { colorscheme = { "habamax" } },
  checker = { enabled = false }
})

