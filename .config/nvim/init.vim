
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
set cursorline
set termguicolors
set ssop-=options
set ssop-=folds
set fillchars=eob:\ 

" plugin setup
lua require('config.lazy')

" early exit if environment variable is set
if $NVIM_MINIMAL != ""
    finish
endif

" lsp setup
lua require('config.lsp')

" neovide-specific setup
lua require('config.neovide')

" custom mappings
nnoremap <silent> <C-S-H> <cmd>tabprev<cr>
nnoremap <silent> <C-S-L> <cmd>tabnext<cr>
nnoremap <silent> <C-Q> <cmd>wincmd q<cr>

" window switching
nnoremap <silent> <C-h> <cmd>wincmd h<cr>
nnoremap <silent> <C-j> <cmd>wincmd j<cr>
nnoremap <silent> <C-k> <cmd>wincmd k<cr>
nnoremap <silent> <C-l> <cmd>wincmd l<cr>

" telescope
nnoremap <leader>: <cmd>Telescope<cr>
nnoremap <leader>f <cmd>Telescope find_files<cr>
nnoremap <leader>g <cmd>Telescope live_grep<cr>
nnoremap <leader>b <cmd>Telescope buffers<cr>
nnoremap <leader>h <cmd>Telescope help_tags<cr>
nnoremap <leader>t <cmd>Telescope telescope-tabs list_tabs<cr>
nnoremap <leader>cd <cmd>Telescope zoxide list previewer=false<cr>

" vimwiki bindings
nnoremap <C-X> <cmd>VimwikiToggleListItem<cr>
nnoremap <leader><c-cr> <cmd>VimwikiTabnewLink<cr>
nnoremap <leader><cr> <cmd>call vimwiki#base#follow_link('tab', 0, 0)<cr>
nnoremap <leader>wp :e ~/sync/wiki/personal.md<cr>
nnoremap <leader>wo :e ~/sync/wiki/work.md<cr>
nnoremap <leader>cc :e ~/.config/nvim/init.vim<cr>

" terminal keymappings
lua require('config.terminals')

" evaluate lua file shortcut
lua <<EOF
vim.keymap.set("n", "<leader>gf", function()
    vim.cmd("luafile " .. vim.fn.expand("<cWORD>"))
end, { noremap = true })
EOF

" swap between buffers with <leader><leader>
nnoremap <leader><leader> <C-^>

" clear search highlight with esc
nnoremap <silent> <Esc> :noh<CR><Esc>

" normal mode in terminal via esc
tnoremap <Esc> <C-\><C-n>
tnoremap <C-Esc> <Esc>

" shortcut for :put call
nnoremap <leader>H :put=execute('hi')

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

    set conceallevel=2
    set concealcursor=ncv
endfun
augroup ft_vimwiki
  autocmd!
  autocmd Syntax vimwiki call s:vimwiki()
augroup end

