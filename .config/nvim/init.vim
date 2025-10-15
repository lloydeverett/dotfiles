
" leader config
nnoremap <SPACE> <Nop>
let mapleader = " "
let maplocalleader = "\\"

" plugin setup
lua require('config.lazy')

" early exit if environment variable is set
if $NVIM_MINIMAL != ""
    finish
endif

" evaluate init.lua
lua require('init')

" window switching
tnoremap <Esc> <C-\><C-n>
tnoremap <C-Esc> <Esc>
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
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l

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

" oil
lua <<EOF
_G["" .. "open_terminal_in_buffer_dir"] = function()
    local dir = vim.fn.expand("%:p:h")
    if dir:find("oil://", 1, true) == 1 then
        dir = dir:sub(#"oil://" + 1)
    end
    vim.cmd('terminal cd "' .. dir .. '" && $SHELL')
end
EOF
nnoremap - <cmd>Oil<cr>
nnoremap <leader>- <cmd>Oil<cr>
nnoremap = <cmd>lua open_terminal_in_buffer_dir()<cr>i
nnoremap <leader>= <cmd>lua open_terminal_in_buffer_dir()<cr>i
nnoremap _ <cmd>split<cr><cmd>wincmd j<cr><cmd>Oil<cr>
nnoremap <leader>_ <cmd>split<cr><cmd>wincmd j<cr><cmd>Oil<cr>
nnoremap + <cmd>split<cr><cmd>wincmd j<cr><cmd>lua open_terminal_in_buffer_dir()<cr>i
nnoremap <leader>+ <cmd>split<cr><cmd>wincmd j<cr><cmd>lua open_terminal_in_buffer_dir()<cr>i

" timers
nnoremap <leader>1 <cmd>TimerStart 2.5m<cr>
nnoremap <leader>2 <cmd>TimerStart 5m<cr>
nnoremap <leader>3 <cmd>TimerStart 15m<cr>
nnoremap <leader>4 <cmd>TimerStart 25m<cr>
nnoremap <leader>0 <cmd>TimerStart 25m<cr>
nnoremap <leader>p :TimerStart<Space>

" swap between buffers
nnoremap <leader><leader> <C-^>

" clear search highlight
noremap <silent> <Esc> :noh<CR><Esc>

" normal mode in terminal via esc
tnoremap <Esc> <C-\><C-n>

" tab switching
nnoremap <leader><Tab> :tabnext<cr>
nnoremap <leader><S-Tab> :tabprev<cr>

" shortcut for :put call
nnoremap <leader>H :put=execute('hi')

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

" don't replace register by default when pasting in visual mode
xnoremap p "_dP

" update buffer when file changes
set autoread
au CursorHold * checktime

" folding
set foldmethod=indent
set foldlevelstart=99
autocmd FileType markdown setlocal foldlevelstart=99

" vimwiki highlights
" ~ markdownH1     xxx cterm=bold ctermfg=167 gui=bold guifg=#ea6962
" ~ markdownH2     xxx cterm=bold ctermfg=208 gui=bold guifg=#e78a4e
" ~ markdownH3     xxx cterm=bold ctermfg=214 gui=bold guifg=#d8a657
" ~ markdownH4     xxx cterm=bold ctermfg=142 gui=bold guifg=#a9b665
" ~ markdownH5     xxx cterm=bold ctermfg=109 gui=bold guifg=#7daea3
" ~ markdownH6     xxx cterm=bold ctermfg=175 gui=bold guifg=#d3869b
hi VimwikiBold guifg=#FF3D5B gui=bold
hi VimwikiItalic guifg=#FF6F91 gui=italic
hi VimwikiHeader1 cterm=bold ctermfg=142 gui=bold guifg=#a9b665
hi VimwikiBold guifg=#FF3D5B gui=bold
hi VimwikiItalic guifg=#FF6F91 gui=italic

" highlight group for trailing whitespace
highlight TrailingWhitespace ctermbg=235 guibg=#3c3836
call matchadd("TrailingWhitespace", '\v\s+$')

