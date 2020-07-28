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

" improve auto-indenting
set smarttab
set smartindent

" load filetype-specific settings
filetype plugin on

" enable syntax highlighting
syntax on

" use ayu dark theme
set termguicolors
let ayucolor="dark"
colorscheme ayu
