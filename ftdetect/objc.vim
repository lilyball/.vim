" Disambiguation variable for objc vs matlab vs mma
let g:filetype_m='objc'

" Vim provides no disambiguation variable for objcpp
" The alternative is nroff. We don't want that.
au BufRead,BufNewFile *.mm set filetype=objcpp
