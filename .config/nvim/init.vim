set scrolloff=5

tnoremap <Esc> <C-\><C-n>
tnoremap <C-e> <Esc>
tnoremap <A-h> <C-\><C-N><C-w>h
tnoremap <A-j> <C-\><C-N><C-w>j
tnoremap <A-k> <C-\><C-N><C-w>k
tnoremap <A-l> <C-\><C-N><C-w>l
inoremap <A-h> <C-\><C-N><C-w>h
inoremap <A-j> <C-\><C-N><C-w>j
inoremap <A-k> <C-\><C-N><C-w>k
inoremap <A-l> <C-\><C-N><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

set laststatus=0
set relativenumber
set nu rnu

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#branch#enabled = 0

" let g:airline#extensions#battery#enabled = 1
" let g:battery#component_format = '%s %v'

call plug#begin()
    " Color schemes
    Plug 'fxn/vim-monochrome'
    Plug 'ellisonleao/gruvbox.nvim'
    Plug 'ntk148v/komau.vim'
    Plug 'davidosomething/vim-colors-meh'
    Plug 'zekzekus/menguless'

    Plug 'vimwiki/vimwiki', { 'branch': 'dev' }
    Plug 'stevearc/oil.nvim'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-lua/popup.nvim'
    Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }
    Plug 'godlygeek/tabular'
    Plug 'preservim/vim-markdown'
    Plug 'tpope/vim-fugitive'
    Plug 'LukasPietzschmann/telescope-tabs'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'neovim/nvim-lspconfig'
    Plug 'mason-org/mason.nvim'
    Plug 'mason-org/mason-lspconfig.nvim'
    Plug 'neovim/nvim-lspconfig'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'hrsh7th/cmp-cmdline'
    Plug 'hrsh7th/nvim-cmp'
    Plug 'hrsh7th/cmp-vsnip'
    Plug 'hrsh7th/vim-vsnip'
    Plug 'tbabej/taskwiki'
    Plug 'powerman/vim-plugin-AnsiEsc'
    Plug 'farseer90718/vim-taskwarrior'
    " Plug 'preservim/tagbar'
    " Plug 'gabenespoli/vim-mutton'

    Plug 'jvgrootveld/telescope-zoxide'

    " Plug 'enricobacis/vim-airline-clock' " airline clock
    " Plug 'lambdalisue/vim-battery' " airline battery
    " Plug 'altermo/nwm' " neovim window manager
    " Plug 'Shougo/deol.nvim'
call plug#end()

lua package.path = package.path .. ';' .. os.getenv('HOME') .. '/.config/nvim/?.lua'
lua require('initlocal')
lua require('initlua')

nnoremap <SPACE> <Nop>
let mapleader = " "

nnoremap <leader>: <cmd>Telescope<cr>
nnoremap <leader>f <cmd>Telescope find_files<cr>
nnoremap <leader>g <cmd>Telescope live_grep<cr>
nnoremap <leader>b <cmd>Telescope buffers<cr>
nnoremap <leader>h <cmd>Telescope help_tags<cr>
nnoremap <leader>t <cmd>Telescope telescope-tabs list_tabs<cr>
nnoremap <leader>cd <cmd>Telescope zoxide list previewer=false<cr>

" nnoremap <leader>. <cmd>call deol#start()<cr>

nnoremap <C-X> <cmd>VimwikiToggleListItem<cr>

nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l

nnoremap <leader><c-cr> <cmd>VimwikiTabnewLink<cr>
nnoremap <leader><cr> <cmd>call vimwiki#base#follow_link('tab', 0, 0)<cr>

nnoremap - <cmd>Oil<cr>
nnoremap <leader>- <cmd>Oil<cr>

nnoremap <leader><leader> <C-^>

noremap <silent> <Esc> :noh<CR><Esc>

tnoremap <Esc> <C-\><C-n>
nnoremap <leader><Tab> :tabnext<cr>
nnoremap <leader><S-Tab> :tabprev<cr>

nnoremap <leader>wp :e ~/sync/wiki/personal.md<cr>
nnoremap <leader>wo :e ~/sync/wiki/work.md<cr>
nnoremap <leader>ec :e ~/.config/nvim/init.vim<cr>

set nowrap

set hidden

set nocompatible
filetype plugin on
syntax on

set autoread
au CursorHold * checktime

set foldlevelstart=99

set expandtab autoindent tabstop=4 shiftwidth=4

let g:vimwiki_emoji_enable = 1
let g:vimwiki_folding = 'list'

" autocmd FileType deol call s:deol_settings()
" function! s:deol_settings()
"   nnoremap <buffer> <C-n>  <Plug>(deol_next_prompt)
"   nnoremap <buffer> <C-p>  <Plug>(deol_previous_prompt)
"   nnoremap <buffer> <CR>   <Plug>(deol_execute_line)
"   nnoremap <buffer> A      <Plug>(deol_start_append_last)
"   nnoremap <buffer> I      <Plug>(deol_start_insert_first)
"   nnoremap <buffer> a      <Plug>(deol_start_append)
"   nnoremap <buffer> e      <Plug>(deol_edit)
"   nnoremap <buffer> i      <Plug>(deol_start_insert)
"   nnoremap <buffer> q      <Plug>(deol_quit)
" endfunction

" autocmd BufEnter deol-edit@default call s:deol_edit_settings()
" function! s:deol_edit_settings()
"   nnoremap <buffer> <CR>  <Plug>(deol_execute_line)
"   nnoremap <buffer> <BS>  <Plug>(deol_backspace)
"   nnoremap <buffer> <C-h> <Plug>(deol_backspace)
"   nnoremap <buffer> q     <Plug>(deol_quit)
"   nnoremap <buffer> <C-c> <Plug>(deol_ctrl_c)
"   inoremap <buffer> <CR>  <Plug>(deol_execute_line)
"   inoremap <buffer> <BS>  <Plug>(deol_backspace)
"   inoremap <buffer> <C-h> <Plug>(deol_backspace)
"   inoremap <buffer> <C-c> <Plug>(deol_ctrl_c)
"   inoremap <buffer> <C-d> <Plug>(deol_ctrl_d)
" endfunction

hi def link markdownH1 GruvboxAquaBold
hi def link markdownH2 GruvboxGreenBold
hi def link markdownH3 GruvboxOrangeBold
hi def link VimwikiHeader1 GruvboxAquaBold
hi def link VimwikiHeader2 GruvboxGreenBold
hi def link VimwikiHeader3 GruvboxOrangeBold

set noswapfile
set undofile
set undodir=~/.local/share/nvim/undo/

set cursorline

function s:global_highlight_config()
  hi Normal ctermbg=NONE guibg=NONE
  hi VimwikiBold guifg=#FF3D5B gui=bold
  hi VimwikiItalic guifg=#FF6F91 gui=italic
endfunction

" command Slay call s:slay()
" function! s:slay()
"   colorscheme monochrome
"   AirlineTheme base16_harmonic_dark
"   call s:global_highlight_config()
" endfunction
"
" command Slain call s:slain()
" function! s:slain()
"   colorscheme gruvbox
"   AirlineTheme base16_darktooth
"   call s:global_highlight_config()
" endfunction

colorscheme gruvbox
let g:airline_theme='base16_darktooth'
call s:global_highlight_config()

let @t = '0"%p$vhhd?\/v0dyypv$hr=Ä˝5:noh'

