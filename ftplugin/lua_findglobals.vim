" run findglobals.lua on the current file

let s:luafile = split(globpath(&rtp, "misc/findglobals.lua"), "\n")[0]

command! -buffer Globals call s:FindGlobals()

function! s:FindGlobals()
	execute '!luac -l -p % | lua' s:luafile '%'
endfunction
