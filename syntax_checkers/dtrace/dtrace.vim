"============================================================================
"File:        dtrace.vim
"Description: Syntax checking plugin for syntastic.vim
"Maintainer:  Lily Ballard <lily at sb dot org>
"License:     This program is free software. It comes without any warranty,
"             to the extent permitted by applicable law. You can redistribute
"             it and/or modify it under the terms of the Do What The Fuck You
"             Want To Public License, Version 2, as published by Sam Hocevar.
"             See http://sam.zoy.org/wtfpl/COPYING for more details.
"
"============================================================================

if exists("g:loaded_syntastic_dtrace_dtrace_checker")
    finish
endif
let g:loaded_syntastic_dtrace_dtrace_checker = 1

let s:save_cpo = &cpo
set cpo&vim

function! SyntaxCheckers_dtrace_dtrace_GetLocList() dict
    let args = {  'fname_before': '-s',
                \ 'args_after':   '-e' }

    if getline(1) =~ "^#!.*dtrace.*-C"
        let args['args_after'] .= ' -C'
    endif
    let makeprg = self.makeprgBuild(args)

    let errorformat = 'dtrace: failed to compile script %f: line %l: %m'

    return SyntasticMake({
                \ 'makeprg': makeprg,
                \ 'errorformat': errorformat })
endfunction

call g:SyntasticRegistry.CreateAndRegisterChecker({
            \ 'filetype': 'dtrace',
            \ 'name': 'dtrace' })

let &cpo = s:save_cpo
unlet s:save_cpo

if !exists("g:syntastic_extra_filetypes")
    let g:syntastic_extra_filetypes = []
endif
let g:syntastic_extra_filetypes += ['dtrace']

" vim: set et sts=4 sw=4:
