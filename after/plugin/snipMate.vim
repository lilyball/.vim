" File: snippet.vim
" Author: Kevin Ballard
" Description: Overrides for snipMate .snippets settings
" Last Modified: May 28, 2014

au FileType snippet setl fdm=expr fde=MySnippetFoldLevel(v:lnum)

function! MySnippetFoldLevel(lnum)
    if getline(a:lnum) =~ '^#\|^\s*$'
        return -1
    endif
    return indent(a:lnum)
endfunction
