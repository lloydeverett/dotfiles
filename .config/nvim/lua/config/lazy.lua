
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
      -- color schemes --------------------------------------------------------------------------------------------
      { 'sainnhe/gruvbox-material',
           config = function(_, _)
               vim.g.gruvbox_material_background = 'medium'
               vim.cmd("colorscheme gruvbox-material")
           end
      },
      { 'sainnhe/everforest',
           config = function(_, _)
               vim.g.everforest_background = 'hard'
           end
      },
      { 'sainnhe/sonokai',
           config = function(_, _)
               vim.g.sonokai_background = 'hard'
           end,
      },

      -- plugins --------------------------------------------------------------------------------------------------
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
                   themeable = true,
                   show_close_icon = false,
                   show_buffer_close_icons = false
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
                       -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                       ['<Tab>'] = cmp.mapping.confirm({ select = true }),
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
               cmp.setup.filetype('vimwiki', {
                   sources = {},
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
           dependencies = { "nvim-lua/plenary.nvim" },
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
               -- vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
               -- vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)
           end
      },
      { "folke/todo-comments.nvim",
           dependencies = { "nvim-lua/plenary.nvim" },
           opts = { }
      },
      { "jake-stewart/multicursor.nvim",
          branch = "1.0",
          config = function(_, _)
              local mc = require("multicursor-nvim")
              mc.setup()
              -- Add or skip cursor above/below the main cursor.
              vim.keymap.set({"n", "x"}, "<up>", function() mc.lineAddCursor(-1) end)
              vim.keymap.set({"n", "x"}, "<down>", function() mc.lineAddCursor(1) end)
              vim.keymap.set({"n", "x"}, "<C-k>", function() mc.lineAddCursor(-1) end)
              vim.keymap.set({"n", "x"}, "<C-j>", function() mc.lineAddCursor(1) end)
              vim.keymap.set({"n", "x"}, "<leader><up>", function() mc.lineSkipCursor(-1) end)
              vim.keymap.set({"n", "x"}, "<leader><down>", function() mc.lineSkipCursor(1) end)
              -- Add or skip adding a new cursor by matching word/selection
              vim.keymap.set({"n", "x"}, "<C-n>", function() mc.matchAddCursor(1) end)
              vim.keymap.set({"n", "x"}, "<C-s>", function() mc.matchSkipCursor(1) end)
              vim.keymap.set({"n", "x"}, "<C-S-N>", function() mc.matchAddCursor(-1) end)
              vim.keymap.set({"n", "x"}, "<C-S-S>", function() mc.matchSkipCursor(-1) end)
              -- Add and remove cursors with control + left click.
              vim.keymap.set("n", "<c-leftmouse>", mc.handleMouse)
              vim.keymap.set("n", "<c-leftdrag>", mc.handleMouseDrag)
              vim.keymap.set("n", "<c-leftrelease>", mc.handleMouseRelease)
              -- Disable and enable cursors.
              vim.keymap.set({"n", "x"}, "<c-q>", mc.toggleCursor)
              -- Mappings defined in a keymap layer only apply when there are
              -- multiple cursors. This lets you have overlapping mappings.
              mc.addKeymapLayer(function(layerSet)
                  -- Select a different cursor as the main one.
                  layerSet({"n", "x"}, "<left>", mc.prevCursor)
                  layerSet({"n", "x"}, "<right>", mc.nextCursor)
                  -- Delete the main cursor.
                  layerSet({"n", "x"}, "<leader>x", mc.deleteCursor)
                  -- Enable and clear cursors using escape.
                  layerSet("n", "<esc>", function()
                      if not mc.cursorsEnabled() then
                          mc.enableCursors()
                      else
                          mc.clearCursors()
                      end
                  end)
              end)
              -- Customize how cursors look.
              vim.api.nvim_set_hl(0, "MultiCursorCursor", { reverse = true })
              vim.api.nvim_set_hl(0, "MultiCursorVisual", { link = "Visual" })
              vim.api.nvim_set_hl(0, "MultiCursorSign", { link = "SignColumn"})
              vim.api.nvim_set_hl(0, "MultiCursorMatchPreview", { link = "Search" })
              vim.api.nvim_set_hl(0, "MultiCursorDisabledCursor", { reverse = true })
              vim.api.nvim_set_hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
              vim.api.nvim_set_hl(0, "MultiCursorDisabledSign", { link = "SignColumn"})
          end
      },
      { "chomosuke/term-edit.nvim",
           opts = {
               prompt_end = '%% ',
           }
      },
      { 'psliwka/termcolors.nvim' }, -- :TermcolorsShow to output terminal color scheme
      { 'Makaze/AnsiEsc' }, -- :AnsiEsc to toggle colorize according to escape seqeunces
      { 'norcalli/nvim-colorizer.lua', -- highlight hex colour codes
           config = function(_, _)
               require('colorizer').setup()
           end
      },

      -- treectl --------------------------------------------------------------------------------------------------
      { 'MunifTanjim/nui.nvim',
           include_in_minimal = true
      },
      { dir = "~/treectl",
           dependencies = { 'MunifTanjim/nui.nvim' },
           include_in_minimal = true,
           opts = {},
           config = function(_, opts)
               require("treectl").setup(opts)
               vim.api.nvim_set_keymap('n', '<leader>[', '<Cmd>Treectl<CR>', { noremap = true, silent = true })
               vim.api.nvim_set_keymap('n', '<leader>]', '<Cmd>TreectlNewBuf<CR>', { noremap = true, silent = true })
           end
      }

  }),
  install = { colorscheme = { "habamax" } },
  checker = { enabled = false }
})

