"------------------------------------------------------------------------------
" Plugins
"------------------------------------------------------------------------------

call plug#begin()

" color schemes based on current pywal theme
Plug 'dylanaraps/wal.vim'
" automatic linting and code checking
Plug 'vim-syntastic/syntastic'

call plug#end()

"------------------------------------------------------------------------------
" Vim tweaks
"------------------------------------------------------------------------------

" automatic code indenting
set autoindent

" vertical bar to help gauge line lengths
set colorcolumn=80

" show search results as search query is typed
set incsearch

" allow the mouse to be used for scrolling and highlighting without affecting
" pasting into vim with middle-click
set mouse=nv

" line numbers are needed
set number

" spellcheck
set spell
set spelllang=en_us

" improve auto-indenting
set smarttab
set smartindent

"------------------------------------------------------------------------------
" Plugin tweaks
"------------------------------------------------------------------------------

" syntastic setup
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1

"------------------------------------------------------------------------------
" Commands and auto-commands
"------------------------------------------------------------------------------

" easier buffer manipulation 
map gn :bn<CR>
map gb :bp<CR>
map gd :bd<CR>

"------------------------------------------------------------------------------
" Other
"------------------------------------------------------------------------------

filetype plugin on
colorscheme wal
