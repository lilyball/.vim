setl expandtab tabstop=4 softtabstop=-1 shiftwidth=4
setl linebreak nolist

let s:undo = 'setl et< st< sts< sw< lbr< list<'
if exists('b:undo_ftplugin')
    let b:undo_ftplugin .= '|' . s:undo
else
    let b:undo_ftplugin = s:undo
endif
unlet s:undo
