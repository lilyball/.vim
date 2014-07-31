let s:save_cpo = &cpo
set cpo&vim

setl tw=78

setl nolist linebreak
setl et sw=4 ts=4 sts=0
setl autoindent nocindent nosmartindent
setl fo=troqnlj

let s:undo = "
            \ setl tw< list< linebreak<
            \|setl et< sw< ts< sts<
            \|setl autoindent< cindent< smartindent<
            \|setl fo<
            \"
if exists('b:undo_ftplugin')
    let b:undo_ftplugin .= '|' . s:undo
else
    let b:undo_ftplugin = s:undo
endif
unlet s:undo

let &cpo = s:save_cpo
unlet s:save_cpo
