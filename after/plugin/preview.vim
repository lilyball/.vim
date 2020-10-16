" File: after/preview.vim
" Author: Lily Ballard
" Description: Defines menus for the Preview plugin
" Last Modified: June 08, 2014

if !exists(":Preview")
    " plugin must not be present
    finish
endif

if exists("loaded_preview_after")
    finish
endif
let loaded_preview_after = 1

let s:save_cpo = &cpo
set cpo&vim

noremenu <silent> &Plugin.&Preview.Show\ Preview :Preview<CR>

let &cpo=s:save_cpo
unlet s:save_cpo

" vim: set et sw=4 ts=4:
