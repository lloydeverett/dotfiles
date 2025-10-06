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

require("lazy").setup({
  spec = {
      -- begin color schemes
      { 'ellisonleao/gruvbox.nvim' },
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
          branch = 'dev' },
      { 'stevearc/oil.nvim' },
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-lua/popup.nvim' },
      { 'nvim-telescope/telescope.nvim', tag = '0.1.8' },
      { 'godlygeek/tabular' },
      { 'preservim/vim-markdown' },
      { 'preservim/nerdtree' },
      { 'tpope/vim-fugitive' },
      { 'LukasPietzschmann/telescope-tabs' },
      { 'vim-airline/vim-airline' },
      { 'vim-airline/vim-airline-themes' },
      { 'neovim/nvim-lspconfig' },
      { 'mason-org/mason.nvim' },
      { 'mason-org/mason-lspconfig.nvim' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'hrsh7th/cmp-cmdline' },
      { 'hrsh7th/nvim-cmp' },
      { 'hrsh7th/cmp-vsnip' },
      { 'hrsh7th/vim-vsnip' },
      { 'tbabej/taskwiki' },
      { 'jvgrootveld/telescope-zoxide' },
      { 'declancm/cinnamon.nvim' },
      { 'MunifTanjim/nui.nvim' },
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
           cmd = 'Nerdy',
           dependencies = {
               'folke/snacks.nvim',
           },
           opts = {
               max_recents = 30, -- Configure recent icons limit
               add_default_keybindings = true, -- Add default keybindings
               copy_to_clipboard = false, -- Copy glyph to clipboard instead of inserting
           }
      },
      -- { 'powerman/vim-plugin-AnsiEsc' },
  },
  install = { colorscheme = { "habamax" } },
  checker = { enabled = false }
})

