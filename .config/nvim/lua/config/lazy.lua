-- Bootstrap lazy.nvim
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

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
      -- begin color schemes
      { 'fxn/vim-monochrome' },
      { 'ellisonleao/gruvbox.nvim' },
      { 'ntk148v/komau.vim' },
      { 'davidosomething/vim-colors-meh' },
      { 'zekzekus/menguless' },
      { 'EdenEast/nightfox.nvim' },
      -- end color schemes
      { 'vimwiki/vimwiki', branch = 'dev' },
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
      { 'powerman/vim-plugin-AnsiEsc' },
      { 'farseer90718/vim-taskwarrior' },
      { 'jvgrootveld/telescope-zoxide' },
      { 'declancm/cinnamon.nvim' },
      { 'stevearc/aerial.nvim' },
      { 'MunifTanjim/nui.nvim' },
      { 'karb94/neoscroll.nvim' },
      { 'rcarriga/nvim-notify' },
      { 'epwalsh/pomo.nvim' }
  },
  install = { colorscheme = { "habamax" } },
  checker = { enabled = false }
})

