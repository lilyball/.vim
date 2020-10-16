" Vim syntax file
" Language:    OpenStep ASCII Property List
" Maintainer:  Lily Ballard
" Last Change: Jul 14, 2014

if version < 600
    syntax clear
elseif exists('b:current_syntax')
    finish
endif

" Settings {{{1
setl foldlevel=99 foldmethod=syntax

" Syntax definitions {{{1

" nsInvalid {{{2

" nsInvalid is the fallback match for dictionary/array contents
" it is defined first so anything else can override it
syn match nsInvalid /\S[^[:space:],;)}]*/ contained contains=@nsInvalidNest
syn region nsInvalidNestString start=,", skip=,\\., end=,", contained
syn region nsInvalidNestArray matchgroup=nsInvalidNestArray start=,(, end=,), contained contains=@nsInvalidNest extend
syn region nsInvalidNestDictionary matchgroup=nsInvalidNestDictionary start=,{, end=,}, contained contains=@nsInvalidNest extend
syn cluster nsInvalidNest contains=nsComment,nsBlockComment,nsInvalidNestString,nsInvalidNestArray,nsInvalidNestDictionary

" Literals {{{2

syn region nsString start=,", skip=,\\., end=,", extend contains=nsEscape,nsEscapeInvalid
syn match nsEscapeInvalid /\\U\x\{0,3}/ contained
" I don't know precisely what escapes work. The ones here are the ones I know
" are valid. Others may work as well.
syn match nsEscape /\\\%(n\|t\|"\|U\x\{4}\|U\x\{0,3}\%($\|\zs"\)\)/ contained
syn match nsString ,\w\+,

syn match nsNumber ,\d\+\%(\.\d\+\)\=,

" Comments {{{2

syn match nsComment ,//.*, excludenl extend contains=@Spell
syn region nsBlockComment start=,/\*, end=,\*/, extend contains=@Spell

" }}}2

" A number of regions here use a trick where they set the end pattern to ,\ze,
" and rely on contained patterns to extend them. This should cause the pattern
" to end as soon as possible. It's possibly a bit iffy though.
" NB: It uses ,\ze, instead of ,, because an empty pattern is not allowed.

" Dictionaries {{{2

syn region nsDictionary matchgroup=nsDictionaryDelim start=,{, end=,}, keepend extend contains=nsDictionaryEntry,nsInvalid,nsComment,nsBlockComment fold
syn region nsDictionaryEntry start=,", start=,\w, end=,\ze, contained contains=nsString nextgroup=nsDictionaryEqual,nsInvalid skipwhite skipempty
syn match nsDictionaryEqual ,=, contained nextgroup=nsDictionaryValue,nsInvalid skipwhite skipempty
syn region nsDictionaryEqual start=,//, start=,/\*, end=,\ze, contained contains=nsComment,nsBlockComment nextgroup=nsDictionaryEqual,nsInvalid skipwhite skipempty
syn region nsDictionaryValue start=,["{(], start=,\w, end=,\ze, contained contains=TOP nextgroup=nsDictionarySemicolon,nsInvalid skipwhite skipempty
syn region nsDictionaryValue start=,//, start=,/\*, end=,\ze, contained contains=nsComment,nsBlockComment nextgroup=nsDictionaryValue,nsInvalid skipwhite skipempty
syn match nsDictionarySemicolon ,;, contained
syn region nsDictionarySemicolon start=,//, start=,/\*, end=,\ze, contained contains=nsComment,nsBlockComment nextgroup=nsDictionarySemicolon,nsInvalid skipwhite skipempty

" Arrays {{{2

syn region nsArray matchgroup=nsArrayDelim start=,(, end=,), keepend extend contains=nsArrayEntry,nsInvalid fold
syn region nsArrayEntry start=,["{(], start=,\w, end=,\ze, contained contains=TOP nextgroup=nsArrayComma,nsInvalid skipwhite skipempty
syn region nsArrayEntry start=,//, start=,/\*, end=,\ze, contained contains=nsBlock,nsBlockComment nextgroup=nsArrayEntry,nsInvalid skipwhite skipempty
syn match nsArrayComma "," contained
syn region nsArrayComma start=,//, start=,/\*, end=,\ze, contained contains=nsBlock,nsBlockComment nextgroup=nsArrayComma,nsInvalid skipwhite skipempty

" Default highlighting {{{1
hi def link nsString        String
hi def link nsEscapeInvalid Error
hi def link nsEscape        Special

hi def link nsNumber        Number

hi def link nsInvalid               Error
hi def link nsInvalidNestString     Error
hi def link nsInvalidNestArray      Error
hi def link nsInvalidNestDictionary Error

hi def link nsComment       Comment
hi def link nsBlockComment  Comment

" }}}1

syn sync minlines=200
syn sync maxlines=500

let b:current_syntax = 'openstep'

" vim: set et sw=4 ts=4:
