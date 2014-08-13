setl expandtab tabstop=4 softtabstop=-1 shiftwidth=4
setl linebreak nolist

if exists('b:undo_ftplugin')
    let b:undo_ftplugin .= '| setl et< st< sts< sw< lbr< list<'
endif
