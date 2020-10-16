" File: ftdetect/openstep.vim
" Author: Lily Ballard
" Description: Filetype detection file for OpenStep ASCII Property List
" Last Change: Jul 14, 2014

function! s:Detect()
    if getline(1) =~ '^\%({\|(\)'
        setf openstep
    endif
endfunction

au BufRead,BufNewFile *.dict,*.plist call <SID>Detect()
