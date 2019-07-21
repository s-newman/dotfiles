setlocal colorcolumn=88
setlocal expandtab
setlocal shiftwidth=4
setlocal softtabstop=4
setlocal tabstop=8
setlocal textwidth=87

let g:black_fast = 1
let g:black_virtualenv = '~/envs/black'
let g:syntastic_python_checkers = ['pycodestyle', 'mypy']

autocmd BufWritePre *.py execute ':Black'
