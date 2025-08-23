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

call plug#begin()
    Plug 'vimwiki/vimwiki', { 'branch': 'dev' }
    Plug 'stevearc/oil.nvim'
    Plug 'ellisonleao/gruvbox.nvim'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'lloydeverett/vim-taskpaper'
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
    Plug 'Shougo/deol.nvim'
    Plug 'tbabej/taskwiki'
    Plug 'powerman/vim-plugin-AnsiEsc'
    Plug 'preservim/tagbar'
    Plug 'farseer90718/vim-taskwarrior'
call plug#end()

let g:airline_theme='base16_darktooth'

lua package.path = package.path .. ';' .. os.getenv('HOME') .. '/.config/nvim/?.lua'
lua require('initlocal')
lua require('initlua')

nnoremap <SPACE> <Nop>
let mapleader = " "

nnoremap <leader>c <cmd>Telescope<cr>
nnoremap <leader>f <cmd>Telescope find_files<cr>
nnoremap <leader>g <cmd>Telescope live_grep<cr>
nnoremap <leader>b <cmd>Telescope buffers<cr>
nnoremap <leader>h <cmd>Telescope help_tags<cr>
nnoremap <leader>t <cmd>Telescope telescope-tabs list_tabs<cr>

nnoremap <leader>. <cmd>call deol#start()<cr>

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

noremap <Esc> :noh<CR><Esc>

tnoremap <Esc> <C-\><C-n>
noremap <leader><Tab> :tabnext<cr>
noremap <leader><S-Tab> :tabprev<cr>

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

let g:airline#extensions#tabline#enabled = 1

autocmd FileType deol call s:deol_settings()
function! s:deol_settings()
  nnoremap <buffer> <C-n>  <Plug>(deol_next_prompt)
  nnoremap <buffer> <C-p>  <Plug>(deol_previous_prompt)
  nnoremap <buffer> <CR>   <Plug>(deol_execute_line)
  nnoremap <buffer> A      <Plug>(deol_start_append_last)
  nnoremap <buffer> I      <Plug>(deol_start_insert_first)
  nnoremap <buffer> a      <Plug>(deol_start_append)
  nnoremap <buffer> e      <Plug>(deol_edit)
  nnoremap <buffer> i      <Plug>(deol_start_insert)
  nnoremap <buffer> q      <Plug>(deol_quit)
endfunction

autocmd BufEnter deol-edit@default call s:deol_edit_settings()
function! s:deol_edit_settings()
  nnoremap <buffer> <CR>  <Plug>(deol_execute_line)
  nnoremap <buffer> <BS>  <Plug>(deol_backspace)
  nnoremap <buffer> <C-h> <Plug>(deol_backspace)
  nnoremap <buffer> q     <Plug>(deol_quit)
  nnoremap <buffer> <C-c> <Plug>(deol_ctrl_c)
  inoremap <buffer> <CR>  <Plug>(deol_execute_line)
  inoremap <buffer> <BS>  <Plug>(deol_backspace)
  inoremap <buffer> <C-h> <Plug>(deol_backspace)
  inoremap <buffer> <C-c> <Plug>(deol_ctrl_c)
  inoremap <buffer> <C-d> <Plug>(deol_ctrl_d)
endfunction

hi def link markdownH1 GruvboxGreenBold
hi def link markdownH2 GruvboxAquaBold
hi def link markdownH3 GruvboxOrangeBold

hi def link VimwikiHeader1 GruvboxGreenBold
hi def link VimwikiHeader2 GruvboxAquaBold
hi def link VimwikiHeader3 GruvboxOrangeBold

" g. to toggle oil hidden files

" au BufRead,BufWinEnter,BufNewFile *.{md,mdx,mdown,mkd,mkdn,markdown,mdwn} setlocal syntax=markdown
" au BufRead,BufWinEnter,BufNewFile *.{md,mdx,mdown,mkd,mkdn,markdown,mdwn} setl noai nocin nosi inde=
"
" au BufRead,BufWinEnter,BufNewFile *.{md,mdx,mdown,mkd,mkdn,markdown,mdwn}.{des3,des,bf,bfa,aes,idea,cast,rc2,rc4,rc5,desx} setlocal syntax=markdown
" au BufRead,BufWinEnter,BufNewFile *.{md,mdx,mdown,mkd,mkdn,markdown,mdwn}.{des3,des,bf,bfa,aes,idea,cast,rc2,rc4,rc5,desx} setl noai nocin nosi inde=

set noswapfile
set undofile
set undodir=~/.local/share/nvim/undo//

