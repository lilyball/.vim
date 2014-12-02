setl nosmartindent

if exists('b:undo_ftplugin')
    let b:undo_ftplugin .= '|setl smartindent<'
endif
