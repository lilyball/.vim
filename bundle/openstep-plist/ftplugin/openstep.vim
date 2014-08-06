" File: ftplugin/openstep.vim
" Author: Kevin Ballard
" Description: FileType Plugin for OpenStep ASCII Property List
" Last Change: Aug 05, 2014

if exists('b:did_ftplugin')
    finish
endif
let b:did_ftplugin = 1

let s:save_cpo = &cpo
set cpo&vim

" Settings {{{1

setl noexpandtab

" Cleanup {{{1

let b:undo_ftplugin = "
            \ setl expandtab<
            \"

" }}}


let &cpo = s:save_cpo
unlet s:save_cpo

" vim: set et sw=4 ts=4:
