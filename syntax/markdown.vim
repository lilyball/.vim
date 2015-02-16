" File: syntax/markdown.vim
" Author: Kevin Ballard
" Description: Helper file for markdown syntax
" Last Change: Feb 16, 2015

if !get(g:, 'ft_markdown_loaded_neobundles')
    NeoBundleSource vim-swift
    NeoBundleSource rust.vim
    let s:langs = ['rust', 'objc', 'swift']
    if exists('g:markdown_fenced_languages')
        call filter(s:langs, 'index(g:markdown_fenced_languages, v:val) < 0')
        call extend(g:markdown_fenced_languages, s:langs)
    else
        let g:markdown_fenced_languages = s:langs
    endif
    unlet s:langs
endif
