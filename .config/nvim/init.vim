
" leader config
nnoremap <SPACE> <Nop>
let mapleader = " "
let maplocalleader = "\\"

" adjust defaults
set nocompatible
filetype plugin on
syntax on
set scrolloff=5
set relativenumber
set nu rnu
set expandtab autoindent tabstop=4 shiftwidth=4
set hidden
set nowrap
set noswapfile
set undofile
set undodir=~/.local/share/nvim/undo/
set ssop-=options
set ssop-=folds
set listchars=tab:,nbsp:~
set list
set fillchars=eob:\ 
set noshowmode
set shortmess+=I
set signcolumn=yes:2
set numberwidth=4
aunmenu PopUp.How-to\ disable\ mouse
aunmenu PopUp.-2-

" plugin setup
lua require('config.lazy')

" set colorscheme
lua require('config.colorscheme')

" early exit if environment variable is set
if $NVIM_MINIMAL != ""
    finish
endif

" reconfigure cmdheight
lua require('config.cmdheight')

" lsp setup
lua require('config.lsp')

" neovide-specific setup
lua require('config.neovide')

" tab and window management
nnoremap <silent> <C-S-H> <cmd>tabprev<cr>
nnoremap <silent> <C-S-L> <cmd>tabnext<cr>
nnoremap <silent> <C-Q> <cmd>wincmd q<cr>
nnoremap <silent> <C-h> <cmd>wincmd h<cr>
nnoremap <silent> <C-j> <cmd>wincmd j<cr>
nnoremap <silent> <C-k> <cmd>wincmd k<cr>
nnoremap <silent> <C-l> <cmd>wincmd l<cr>

" file shortcuts
nnoremap <leader>wp :e ~/sync/wiki/personal.md<cr>
nnoremap <leader>wo :e ~/sync/wiki/work.md<cr>
nnoremap <leader>wd :e ~/sync/wiki/diary/<cr>
nnoremap <leader>cc :e ~/.config/nvim/init.vim<cr>
nnoremap <leader>cl :e ~/.config/nvim/lua/config/lazy.lua<cr>
lua <<EOF
vim.keymap.set("n", "<leader>wt", function()
    vim.cmd("e ~/sync/wiki/diary/" .. os.date("%Y-%m-%d") .. ".md")
end, { noremap = true })
EOF

" terminal keymappings
lua require('config.terminals')

" evaluate lua file shortcut
lua <<EOF
vim.keymap.set("n", "<leader>gl", function()
    vim.cmd("luafile " .. vim.fn.expand("<cWORD>"))
end, { noremap = true })
EOF

" like gf but create file if it doesn't exist
lua <<EOF
vim.keymap.set("n", "<leader>gf", function()
    local word = vim.fn.expand("<cWORD>")

    if string.sub(word, 1, 2) == "./" then
        word = vim.fn.expand("%:p:h") .. string.sub(word, 2)
    end

    vim.cmd("e " .. word)
end, { noremap = true })
EOF

" swap between buffers with <leader><leader>
nnoremap <leader><leader> <C-^>

" clear search highlight with esc
nnoremap <silent> <Esc> :noh<CR><Esc>

" normal mode in terminal via esc
tnoremap <Esc> <C-\><C-n>
tnoremap <C-Esc> <Esc>

" alternative bindings for toggling todo items (for Blink on iOS)
nnoremap <silent> <leader>; :VimwikiToggleListItem<CR>

" shortcut for :put call
nnoremap <leader>H :put=execute('hi')

" cursorline
lua <<EOF
vim.api.nvim_create_autocmd({ "FocusGained", "WinEnter", "BufEnter" }, {
    callback = function()
        vim.o.cursorline = true
    end,
})
vim.api.nvim_create_autocmd({ "FocusLost", "WinLeave", "BufLeave" }, {
    callback = function()
        vim.o.cursorline = false
    end,
})
EOF

" don't replace register by default when pasting in visual mode
xnoremap p P

" update buffer when file changes
set autoread
au CursorHold * checktime

" folding
set foldmethod=indent
set foldlevelstart=99
autocmd FileType markdown setlocal foldlevelstart=99

" auto-close terminals when shell exits
autocmd TermClose * execute 'bdelete!'

" custom highlights
lua require('config.highlights')

" custom winbar
lua require('config.winbar')

" custom vimwiki conceal + syntax highlight rules
set conceallevel=2
set concealcursor=ncv
fun s:vimwiki()
    syn match todoCheckbox '\v(\s+)?(-|\*)\s\[\s\]'hs=e-4 conceal cchar=
    syn match todoCheckbox '\v(\s+)?(-|\*)\s\[X\]'hs=e-4 conceal containedin=todoDone cchar=
    syn match todoDone '\v(\s+)?(-|\*)\s\[X\].*$' contains=VimwikiItalic,VimwikiBold
    syn match todoCheckbox '\v(\s+)?(-|\*)\s\[-\]'hs=e-4 conceal cchar=󰅘
    syn match todoCheckbox '\v(\s+)?(-|\*)\s\[\.\]'hs=e-4 conceal cchar=⊡
    syn match todoCheckbox '\v(\s+)?(-|\*)\s\[o\]'hs=e-4 conceal cchar=⬕
    syn match todoCheckbox '\v(\s+)?(-|\*)\s\[/\]'hs=e-4 conceal cchar=

    syn match VimwikiHeader1Setext "=" conceal cchar=═ containedin=VimwikiHeader1 contained
    syn match VimwikiHeader2Setext "-" conceal cchar=─ containedin=VimwikiHeader2 contained

    syn match TodoDateMonth '\d\d\d\d-\d\d[^-]'he=e-1

    set conceallevel=2
    set concealcursor=ncv
endfun
augroup ft_vimwiki
  autocmd!
  autocmd Syntax vimwiki call s:vimwiki()
augroup end

