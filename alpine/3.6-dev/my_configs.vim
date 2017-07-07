" disable folding https://github.com/amix/vimrc/issues/63
set foldlevelstart=99

au FileType html setlocal shiftwidth=2 tabstop=2 expandtab
au FileType yaml setlocal shiftwidth=2 tabstop=2 expandtab
au FileType javascript setlocal shiftwidth=2 tabstop=2 expandtab
autocmd BufNewFile,BufRead *.json set ft=javascript
