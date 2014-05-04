" Used for svn-commit*.tmp

" SVN commits don't have modelines
setl nomodeline

" Reset back to the first line
au BufWinEnter <buffer> :1

" Reset now in case our filetype is being set late
:1
