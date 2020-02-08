"------------------------------------------------------------------------------
" Plugins
"------------------------------------------------------------------------------

call plug#begin()

" git status for each line next to line number
"Plug 'airblade/vim-gitgutter'
" color schemes based on current pywal theme
Plug 'dylanaraps/wal.vim'
" syntax highlighting for terraform files and easy execution
"Plug 'hashivim/vim-terraform'
" automatic python docstrings with ctrl-l
"Plug 'heavenshell/vim-pydocstring'
" support for ledger files
"Plug 'ledger/vim-ledger'
" automatic python formatting
" NOTE: uses 88-character lines
"Plug 'python/black'
" file tree in sidebar
"Plug 'scrooloose/nerdtree'
" running git commands without leaving vim
"Plug 'tpope/vim-fugitive'
" code completion
"Plug 'valloric/youcompleteme'
" status bar
"Plug 'vim-airline/vim-airline'
" improved python syntax highlighting
"Plug 'vim-python/python-syntax'
" automatic linting and code checking
"Plug 'vim-syntastic/syntastic'
" git file statuses in nerdtree
"Plug 'xuyuanp/nerdtree-git-plugin'

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

" show extensions in status bar
let g:airline#extensions#tabline#enabled = 1

" show dotfiles in nerdtree
let g:NERDTreeShowHidden = 1

" extra syntax highlighting for python
let g:python_highlight_all = 1

" syntastic setup
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1

"------------------------------------------------------------------------------
" Commands and auto-commands
"------------------------------------------------------------------------------

" turn off numbers and git statuses with F1 for easier highlight copying
map <F1> :set number! <bar> GitGutterToggle <CR>

" easier buffer manipulation 
map gn :bn<CR>
map gb :bp<CR>
map gd :bd<CR>

" Toggle NERDTree
map gt :NERDTreeToggle<CR>

" only display nerdtree when vim is called without a file
autocmd StdinReadPre * let s:std_in = 1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

"------------------------------------------------------------------------------
" Other
"------------------------------------------------------------------------------

filetype plugin on
colorscheme wal
