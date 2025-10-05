set scrolloff=5
set laststatus=0
set relativenumber
set nu rnu

let g:vimwiki_emoji_enable = 1
let g:treectl#nerd_font = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#branch#enabled = 0
let g:airline_section_z = '%2p%% %1l/%1L %1c'
let g:vim_markdown_folding_disabled = 1
let g:airline_theme='base16_darktooth'

function s:global_highlight_config()
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
call s:global_highlight_config()

nnoremap <SPACE> <Nop>
let mapleader = " "
let maplocalleader = "\\"

lua require('config.lazy')

colorscheme gruvbox

" call plug#begin()
"     " -- begin color schemes
"     Plug 'fxn/vim-monochrome'
"     Plug 'ellisonleao/gruvbox.nvim'
"     Plug 'ntk148v/komau.vim'
"     Plug 'davidosomething/vim-colors-meh'
"     Plug 'zekzekus/menguless'
"     Plug 'EdenEast/nightfox.nvim'
"     " -- end color schemes
"     Plug 'vimwiki/vimwiki', { 'branch': 'dev' }
"     Plug 'stevearc/oil.nvim'
"     Plug 'nvim-lua/plenary.nvim'
"     Plug 'nvim-lua/popup.nvim'
"     Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }
"     Plug 'godlygeek/tabular'
"     Plug 'preservim/vim-markdown'
"     Plug 'preservim/nerdtree'
"     Plug 'tpope/vim-fugitive'
"     Plug 'LukasPietzschmann/telescope-tabs'
"     Plug 'vim-airline/vim-airline'
"     Plug 'vim-airline/vim-airline-themes'
"     Plug 'neovim/nvim-lspconfig'
"     Plug 'mason-org/mason.nvim'
"     Plug 'mason-org/mason-lspconfig.nvim'
"     Plug 'hrsh7th/cmp-nvim-lsp'
"     Plug 'hrsh7th/cmp-buffer'
"     Plug 'hrsh7th/cmp-path'
"     Plug 'hrsh7th/cmp-cmdline'
"     Plug 'hrsh7th/nvim-cmp'
"     Plug 'hrsh7th/cmp-vsnip'
"     Plug 'hrsh7th/vim-vsnip'
"     Plug 'tbabej/taskwiki'
"     Plug 'powerman/vim-plugin-AnsiEsc'
"     Plug 'farseer90718/vim-taskwarrior'
"     Plug 'jvgrootveld/telescope-zoxide'
"     Plug 'declancm/cinnamon.nvim'
"     Plug 'stevearc/aerial.nvim'
"     Plug 'MunifTanjim/nui.nvim'
"     Plug 'karb94/neoscroll.nvim'
"     Plug 'rcarriga/nvim-notify'
"     Plug 'epwalsh/pomo.nvim'
" call plug#end()

" silent! let g:plugs['aerial.nvim'].commit = 'c7cbbad40c2065fccfd1f1863bb2c08180c0533d'
" silent! let g:plugs['cinnamon.nvim'].commit = '450cb3247765fed7871b41ef4ce5fa492d834215'
" silent! let g:plugs['cmp-buffer'].commit = 'b74fab3656eea9de20a9b8116afa3cfc4ec09657'
" silent! let g:plugs['cmp-cmdline'].commit = 'd126061b624e0af6c3a556428712dd4d4194ec6d'
" silent! let g:plugs['cmp-nvim-lsp'].commit = 'a8912b88ce488f411177fc8aed358b04dc246d7b'
" silent! let g:plugs['cmp-path'].commit = 'c642487086dbd9a93160e1679a1327be111cbc25'
" silent! let g:plugs['cmp-vsnip'].commit = '989a8a73c44e926199bfd05fa7a516d51f2d2752'
" silent! let g:plugs['gruvbox.nvim'].commit = '58a2cda2e953a99e2f87c12b7fb4602da4e0709c'
" silent! let g:plugs['komau.vim'].commit = 'c525eebc9a46e889144216dc3a965783abaccf98'
" silent! let g:plugs['mason-lspconfig.nvim'].commit = '7f0bf635082bb9b7d2b37766054526a6ccafdb85'
" silent! let g:plugs['mason.nvim'].commit = '7dc4facca9702f95353d5a1f87daf23d78e31c2a'
" silent! let g:plugs['menguless'].commit = '09072d8edb8f94cc1be63ae2c7ff4ae091189f16'
" silent! let g:plugs['neoscroll.nvim'].commit = 'f957373912e88579e26fdaea4735450ff2ef5c9c'
" silent! let g:plugs['nerdtree'].commit = '9b465acb2745beb988eff3c1e4aa75f349738230'
" silent! let g:plugs['nightfox.nvim'].commit = 'ba47d4b4c5ec308718641ba7402c143836f35aa9'
" silent! let g:plugs['nui.nvim'].commit = 'de740991c12411b663994b2860f1a4fd0937c130'
" silent! let g:plugs['nvim-cmp'].commit = 'b5311ab3ed9c846b585c0c15b7559be131ec4be9'
" silent! let g:plugs['nvim-lspconfig'].commit = '5939928504f688f8ae52db30d481f6a077921f1c'
" silent! let g:plugs['nvim-notify'].commit = '8701bece920b38ea289b457f902e2ad184131a5d'
" silent! let g:plugs['oil.nvim'].commit = 'bbad9a76b2617ce1221d49619e4e4b659b3c61fc'
" silent! let g:plugs['plenary.nvim'].commit = 'b9fd5226c2f76c951fc8ed5923d85e4de065e509'
" silent! let g:plugs['pomo.nvim'].commit = 'aa8decc421d89be0f10b1fc6a602cdd269f350ff'
" silent! let g:plugs['popup.nvim'].commit = 'b7404d35d5d3548a82149238289fa71f7f6de4ac'
" silent! let g:plugs['tabular'].commit = '12437cd1b53488e24936ec4b091c9324cafee311'
" silent! let g:plugs['taskwiki'].commit = 'e7f4335a777b47cf6896651187ce2b9a64b06825'
" silent! let g:plugs['telescope-tabs'].commit = 'd16fae006ba978ccc5c5579d40f358e12a0f8d30'
" silent! let g:plugs['telescope-zoxide'].commit = '54bfe630bad08dc9891ec78c7cf8db38dd725c97'
" silent! let g:plugs['telescope.nvim'].commit = 'a0bbec21143c7bc5f8bb02e0005fa0b982edc026'
" silent! let g:plugs['vim-airline'].commit = '5ca7f0b7fef4f174d57fd741b477bbbac0b7886a'
" silent! let g:plugs['vim-airline-themes'].commit = '0e976956eb674db8a6f72fae4dda6d1277433660'
" silent! let g:plugs['vim-colors-meh'].commit = 'e8620eb2d869b7021bfdeaa6cdd7e4fcc7f14d3f'
" silent! let g:plugs['vim-fugitive'].commit = '61b51c09b7c9ce04e821f6cf76ea4f6f903e3cf4'
" silent! let g:plugs['vim-markdown'].commit = '8f6cb3a6ca4e3b6bcda0730145a0b700f3481b51'
" silent! let g:plugs['vim-monochrome'].commit = 'c4f18812bbdbe640ffddf69e0c5734ec87d6b5e7'
" silent! let g:plugs['vim-plugin-AnsiEsc'].commit = '690f820d20b6e3a79ba20499874eb7333aa4ca5c'
" silent! let g:plugs['vim-taskwarrior'].commit = '8ae6c5ee2ed54d759a58a8d9f67bc76430e3bd25'
" silent! let g:plugs['vim-vsnip'].commit = '0a4b8419e44f47c57eec4c90df17567ad4b1b36e'
" silent! let g:plugs['vimwiki'].commit = '72792615e739d0eb54a9c8f7e0a46a6e2407c9e8'
"
" PlugUpdate!

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

nnoremap <leader>p <cmd>TimerStart 5m<cr>
nnoremap <leader>P <cmd>TimerStart 15m<cr>

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

" macro to generate markdown title based on filename
let @t = '0"%p$vhhd?\/v0dyypv$hr=Ä˝5:noh'

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

