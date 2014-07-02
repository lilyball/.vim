" Used for gitommit, gitrebase, and git object files

" Git files don't have modelines
setl nomodeline

" Tweak indent settings
" We're doing this here instead of in an indent/ file because the git ftplugin
" is used for all git-related files but there's no such behavior for indent.
setl autoindent nosmartindent nocindent copyindent preserveindent

" Reset back to the first line
au BufWinEnter <buffer> :1

" Reset now in case our filetype is being set late
:1
