:set scrolloff=5

:tnoremap <Esc> <C-\><C-n> :tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'
:tnoremap <A-h> <C-\><C-N><C-w>h
:tnoremap <A-j> <C-\><C-N><C-w>j
:tnoremap <A-k> <C-\><C-N><C-w>k
:tnoremap <A-l> <C-\><C-N><C-w>l
:inoremap <A-h> <C-\><C-N><C-w>h
:inoremap <A-j> <C-\><C-N><C-w>j
:inoremap <A-k> <C-\><C-N><C-w>k
:inoremap <A-l> <C-\><C-N><C-w>l
:nnoremap <A-h> <C-w>h
:nnoremap <A-j> <C-w>j
:nnoremap <A-k> <C-w>k
:nnoremap <A-l> <C-w>l

" Jump up or down half a page
:nnoremap <C-J> <C-D>
:nnoremap <C-K> <C-U>

:set laststatus=0
:set relativenumber
:set nu rnu

call plug#begin()
    Plug 'vimwiki/vimwiki'
    Plug 'stevearc/oil.nvim'
    Plug 'ellisonleao/gruvbox.nvim'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'lloydeverett/vim-taskpaper'
    Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }
    Plug 'godlygeek/tabular'
    Plug 'preservim/vim-markdown'
    Plug 'tpope/vim-fugitive'
    Plug 'nvim-tree/nvim-web-devicons'
    Plug 'LukasPietzschmann/telescope-tabs'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
call plug#end()
" Plug 'pwntester/octo.nvim'
" Plug 'famiu/feline.nvim'
" Plug 'tpope/vim-sensible'
" Plug 'mg979/vim-visual-multi', {'branch': 'master'}
" Plug 'francoiscabrol/ranger.vim'
" Plug 'tpope/vim-vinegar'
" Plug 'preservim/nerdtree'
" Plug 'cweagans/vim-taskpaper'
" Plug 'vimwiki/vimwiki'
" Plug 'stevearc/oil.nvim'
" Plug 'morhetz/gruvbox'
" Plug 'mattn/calendar-vim'
" Plug 'jceb/vim-orgmode'
" Plug 'itchyny/lightline.vim'

" let g:airline_theme='base16_black_metal'
let g:airline_theme='base16_darktooth'

lua package.path = package.path .. ';' .. os.getenv('HOME') .. '/.config/nvim/?.lua'
lua require('initlocal')
lua require('initlua')

" let g:NERDTreeWinPos = "right"

" :nnoremap <leader>n :NERDTreeFocus<CR>
" :nnoremap <C-n> :NERDTree<CR>
" :nnoremap <C-t> :NERDTreeToggle<CR>
" :nnoremap <C-f> :NERDTreeFind<CR>

nnoremap <SPACE> <Nop>
let mapleader = " "

:nnoremap <leader>c <cmd>Telescope<cr>
:nnoremap <leader>f <cmd>Telescope find_files<cr>
:nnoremap <leader>g <cmd>Telescope live_grep<cr>
:nnoremap <leader>b <cmd>Telescope buffers<cr>
:nnoremap <leader>h <cmd>Telescope help_tags<cr>
:nnoremap <leader>t <cmd>Telescope telescope-tabs list_tabs<cr>

:nnoremap <C-j> <C-W>j
:nnoremap <C-k> <C-W>k
:nnoremap <C-h> <C-W>h
:nnoremap <C-l> <C-W>l

:nnoremap <leader><cr> <cmd>VimwikiTabnewLink<cr>

nnoremap - <cmd>Oil<cr>
nnoremap <leader>- <cmd>Oil<cr>

nnoremap <leader><leader> <C-^>

:tnoremap <Esc> <C-\><C-n>
:noremap <leader><Tab> :tabnext<cr>
:noremap <leader><S-Tab> :tabprev<cr>

" :autocmd VimEnter * split | wincmd j | exe "Ranger" | wincmd k | exe "resize 50" | call feedkeys("\<ESC>")

" Start NERDTree and put the cursor back in the other window.
" :autocmd VimEnter * NERDTree | wincmd p

" Exit Vim if NERDTree is the only window remaining in the only tab.
" :autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | call feedkeys(":quit\<CR>:\<BS>") | endif

" nvim oil-ssh://[username@]hostname[:port]/[path]

" g. to toggle oil hidden files

" au BufRead,BufWinEnter,BufNewFile *.{md,mdx,mdown,mkd,mkdn,markdown,mdwn} setlocal syntax=markdown
" au BufRead,BufWinEnter,BufNewFile *.{md,mdx,mdown,mkd,mkdn,markdown,mdwn} setl noai nocin nosi inde=
" 
" au BufRead,BufWinEnter,BufNewFile *.{md,mdx,mdown,mkd,mkdn,markdown,mdwn}.{des3,des,bf,bfa,aes,idea,cast,rc2,rc4,rc5,desx} setlocal syntax=markdown
" au BufRead,BufWinEnter,BufNewFile *.{md,mdx,mdown,mkd,mkdn,markdown,mdwn}.{des3,des,bf,bfa,aes,idea,cast,rc2,rc4,rc5,desx} setl noai nocin nosi inde=

:set nowrap

:set hidden

set nocompatible
filetype plugin on
syntax on

set foldlevelstart=99

set expandtab autoindent tabstop=4 shiftwidth=4

let g:vimwiki_emoji_enable = 1
let g:vimwiki_folding = 'list'

let g:airline#extensions#tabline#enabled = 1

