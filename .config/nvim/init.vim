set scrolloff=5
set laststatus=0
set relativenumber
set nu rnu

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#branch#enabled = 0

let g:airline_section_z = '%2p%% %1l/%1L %1c'

let g:vim_markdown_folding_disabled = 1

call plug#begin()
    " -- begin color schemes
    Plug 'fxn/vim-monochrome'
    Plug 'ellisonleao/gruvbox.nvim'
    Plug 'ntk148v/komau.vim'
    Plug 'davidosomething/vim-colors-meh'
    Plug 'zekzekus/menguless'
    " -- end color schemes
    Plug 'vimwiki/vimwiki', { 'branch': 'dev' }
    Plug 'stevearc/oil.nvim'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-lua/popup.nvim'
    Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }
    Plug 'godlygeek/tabular'
    Plug 'preservim/vim-markdown'
    Plug 'preservim/nerdtree'
    Plug 'tpope/vim-fugitive'
    Plug 'LukasPietzschmann/telescope-tabs'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'neovim/nvim-lspconfig'
    Plug 'mason-org/mason.nvim'
    Plug 'mason-org/mason-lspconfig.nvim'
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
    Plug 'jvgrootveld/telescope-zoxide'
    Plug 'declancm/cinnamon.nvim'
    Plug 'stevearc/aerial.nvim'
    Plug 'MunifTanjim/nui.nvim'
    Plug 'karb94/neoscroll.nvim'
    Plug 'folke/twilight.nvim'
call plug#end()

nnoremap <SPACE> <Nop>
let mapleader = " "

lua require('init')
lua require('treectl.treectl')

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

nnoremap <leader>: <cmd>Telescope<cr>
nnoremap <leader>f <cmd>Telescope find_files<cr>
nnoremap <leader>g <cmd>Telescope live_grep<cr>
nnoremap <leader>b <cmd>Telescope buffers<cr>
nnoremap <leader>h <cmd>Telescope help_tags<cr>
nnoremap <leader>t <cmd>Telescope telescope-tabs list_tabs<cr>
nnoremap <leader>cd <cmd>Telescope zoxide list previewer=false<cr>

nnoremap <C-X> <cmd>VimwikiToggleListItem<cr>

nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l

nnoremap <leader><c-cr> <cmd>VimwikiTabnewLink<cr>
nnoremap <leader><cr> <cmd>call vimwiki#base#follow_link('tab', 0, 0)<cr>

nnoremap - <cmd>Oil<cr>
nnoremap <leader>- <cmd>Oil<cr>
nnoremap = <cmd>lua open_terminal_in_buffer_dir()<cr>i
nnoremap <leader>= <cmd>lua open_terminal_in_buffer_dir()<cr>i
nnoremap _ <cmd>split<cr><cmd>wincmd j<cr><cmd>Oil<cr>
nnoremap <leader>_ <cmd>split<cr><cmd>wincmd j<cr><cmd>Oil<cr>
nnoremap + <cmd>split<cr><cmd>wincmd j<cr><cmd>lua open_terminal_in_buffer_dir()<cr>i
nnoremap <leader>+ <cmd>split<cr><cmd>wincmd j<cr><cmd>lua open_terminal_in_buffer_dir()<cr>i

" close terminal as soon as shell exits
autocmd TermClose * if !v:event.status | exe 'bdelete! '..expand('<abuf>') | endif

nnoremap <leader><leader> <C-^>

noremap <silent> <Esc> :noh<CR><Esc>

tnoremap <Esc> <C-\><C-n>
nnoremap <leader><Tab> :tabnext<cr>
nnoremap <leader><S-Tab> :tabprev<cr>

nnoremap <leader>wp :e ~/sync/wiki/personal.md<cr>
nnoremap <leader>wo :e ~/sync/wiki/work.md<cr>
nnoremap <leader>cc :e ~/.config/nvim/init.vim<cr>

set nowrap

set hidden

set nocompatible
filetype plugin on
syntax on

set autoread
au CursorHold * checktime

set expandtab autoindent tabstop=4 shiftwidth=4

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
  hi Normal ctermbg=NONE guibg=#1D1F20
  hi VimwikiBold guifg=#FF3D5B gui=bold
  hi VimwikiItalic guifg=#FF6F91 gui=italic
endfunction

let s:saved_theme = []
let g:airline_theme_patch_func = 'AirlineThemePatch'
function! AirlineThemePatch(palette)
    " let a:palette.colors.airline_term = []
    for colors in values(a:palette)
        if has_key(colors, 'airline_c') && len(s:saved_theme) ==# 0
            let s:saved_theme = colors.airline_c
        endif
        if has_key(colors, 'airline_term')
            let colors.airline_term = s:saved_theme
        endif
    endfor
endfunction

colorscheme gruvbox
let g:airline_theme='base16_darktooth'
call s:global_highlight_config()

" macro to generate markdown title based on filename
let @t = '0"%p$vhhd?\/v0dyypv$hr=Ä˝5:noh'

let g:vimwiki_emoji_enable = 1

xnoremap p "_dP

set foldmethod=indent
set foldlevelstart=99
autocmd FileType markdown setlocal foldlevelstart=99

" let g:vimwiki_folding = 'expr:quick'
" let g:vimwiki_folding = 'custom'
" let g:vimwiki_fold_blank_lines = 0  " set to 1 to fold blank lines
" let g:vimwiki_header_type = '#'     " set to '=' for wiki syntax
" setlocal foldlevel=1
" setlocal foldenable
" setlocal foldmethod=expr
" setlocal foldexpr=Fold(v:lnum)
"  function! Fold(lnum)
"    let fold_level = strlen(matchstr(getline(a:lnum), '^' . l:vimwiki_header_type . '\+'))
"    if (fold_level)
"      return '>' . fold_level  " start a fold level
"    endif
"    if getline(a:lnum) =~? '\v^\s*$'
"      if (strlen(matchstr(getline(a:lnum + 1), '^' . l:vimwiki_header_type . '\+')) > 0 && !g:vimwiki_fold_blank_lines)
"        return '-1' " don't fold last blank line before header
"      endif
"    endif
"    return '=' " return previous fold level
"  endfunction

