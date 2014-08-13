" Fix indentation
setl tabstop=2 shiftwidth=2 expandtab softtabstop=-1

if exists("b:undo_ftplugin")
    let b:undo_ftplugin .= "| setl tabstop< shiftwidth< expandtab< softtabstop<"
endif
