" File: ftplugin/lua.vim
" Author: Lily Ballard
" Description: Adds extra support to the Lua file mode
" Last Change: June 10, 2014

command! -buffer -bar LuaRun :w !lua -

nnoremap <buffer> <D-r> :LuaRun<CR>
