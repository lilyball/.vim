if exists("g:no_plugin_maps") || exists("g:no_gitrebase_maps")
  finish
endif

nnoremap <buffer> <silent> <LocalLeader>p :Pick<CR>
nnoremap <buffer> <silent> <LocalLeader>s :Squash<CR>
nnoremap <buffer> <silent> <LocalLeader>e :Edit<CR>
nnoremap <buffer> <silent> <LocalLeader>r :Reword<CR>
nnoremap <buffer> <silent> <LocalLeader>f :Fixup<CR>
nnoremap <buffer> <silent> <LocalLeader>c :Cycle<CR>
