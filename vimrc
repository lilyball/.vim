" vim: set et sw=2 ts=2:
" Author: Kevin Ballard <kevin@sb.org>
"
" Some of these settings came from Steve Losh
" https://bitbucket.org/sjl/dotfiles/src/tip/vim/vimrc
"
" Others came from https://github.com/bling/dotvim
"
" Still others were hand-crafted over time by me.

" Preamble {{{
if has('vim_starting')
  set nocompatible
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

" Clear vimrc augroup so the rest of the file can add to it
augroup vimrc
  au!
augroup END

" Leader {{{

" Set this before loading bundles.
" It must be defined before mappings are loaded, and I'm not sure if any
" bundle code is loaded when the bundle group ends. So be safe and do it now.

let mapleader = ","
let maplocalleader = "\\"

" }}}

" Turn on syntax now to ensure any appropriate autocommands run after the
" syntax file has loaded.
syntax on

" Disable netrw so explorer plugins (e.g. vimfiler) can be loaded lazily
let g:loaded_netrwPlugin = 1

" }}}
" Bundles {{{

call neobundle#begin(expand('~/.vim/neobundle/'))

" Bundles {{{

if neobundle#has_fresh_cache() &&
      \ neobundle#has_fresh_cache(expand('~/.vim/neobundle/neobundle.toml'))
  NeoBundleLoadCache
else
  NeoBundleFetch 'Shougo/neobundle.vim'

  NeoBundle 'Shougo/vimproc.vim', {
        \ 'build': {
        \    'mac': 'make -f make_mac.mak',
        \    'unix': 'make -f make_unix.mak',
        \    'cygwin': 'make -f make_cygwin.mak',
        \    'windows': 'tools\\update-dll-mingw',
        \   }
        \ }

  call neobundle#load_toml('~/.vim/neobundle/neobundle.toml', {'lazy': 1})

  NeoBundleSaveCache
endif

NeoBundleLocal ~/.vim/bundle

" }}}
" Configuration {{{

if neobundle#tap('ack.vim') "{{{
  function! neobundle#hooks.on_source(bundle)
    let g:ackprg = 'ag --nogroup --nocolor --column'
  endfunction
endif "}}}
if neobundle#tap("CamelCaseMotion") "{{{
  for s:mode in ['n', 'o', 'v']
    for s:motion in ['w', 'b', 'e']
      execute (s:mode ==# 'v' ? 'x' : s:mode) . 'map <silent> <S-' . toupper(s:motion) . '> <Plug>CamelCaseMotion_' . s:motion
    endfor
  endfor
  unlet s:mode
  unlet s:motion

  call neobundle#untap()
endif "}}}
if neobundle#tap('clang_complete') "{{{
  function! neobundle#hooks.on_source(bundle)
    if system("uname") =~? "darwin"
      let g:clang_library_path = "/Library/Developer/CommandLineTools/usr/lib/"
      if !isdirectory(g:clang_library_path)
        let s:devdir = substitute(system("xcode-select --print-path"), '\n$', '', '')
        if v:shell_error != 0 || !isdirectory(s:devdir)
          echom "Could not find Xcode developer directory"
          unlet g:clang_library_path
        else
          let g:clang_library_path = substitute(s:devdir, '/$', '', '') . '/Toolchains/XcodeDefault.xctoolchain/usr/lib/'
        endif
      endif
    endif
  endfunction

  call neobundle#untap()
endif "}}}
if neobundle#tap('command-t') "{{{
  nmap <leader>bb :CommandTBuffer<CR>

  call neobundle#untap()
endif "}}}
if neobundle#tap('delimitMate') "{{{
  let g:delimitMate_expand_cr = 1

  call neobundle#untap()
endif "}}}
if neobundle#tap('gitv') "{{{
  function! neobundle#hooks.on_source(bundle)
    nnoremap <silent> <leader>Gv :Gitv<CR>
    nnoremap <silent> <leader>GV :Gitv!<CR>
  endfunction
endif "}}}
if neobundle#tap('gundo') "{{{
  nnoremap <F5> :GundoToggle<CR>
  let g:gundo_debug = 1
  let g:gundo_preview_bottom = 1

  call neobundle#untap()
endif "}}}
if neobundle#tap('haskellmode') "{{{
  let g:haddock_browser="/usr/bin/open"

  call neobundle#untap()
endif "}}}
if neobundle#tap('html5') "{{{
  let g:event_handler_attributes_complete = 0
  let g:rdfa_attributes_complete = 0
  let g:microdata_attributes_complete = 0
  let g:atia_attributes_complete = 0

  call neobundle#untap()
endif "}}}
if neobundle#tap('jsbeautify') "{{{
  augroup plug_jsbeautify
    au!
    autocmd FileType javascript,json command! -buffer JsBeautify :call JsBeautify()
  augroup END

  call neobundle#untap()
endif "}}}
if neobundle#tap('nerdcommenter') "{{{
  let g:NERDCustomDelimiters = {
        \ 'rust': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/'},
        \ }

  call neobundle#untap()
endif "}}}
if neobundle#tap('preview') "{{{
  let g:PreviewMarkdownFences = 1

  call neobundle#untap()
endif "}}}
if neobundle#tap('snipMate') "{{{
  let g:snips_author = "Kevin Ballard"

  call neobundle#untap()
endif "}}}
if neobundle#tap('syntastic') "{{{
  let g:syntastic_enable_signs = 1
  let g:syntastic_disabled_filetypes = ['html']
  let g:syntastic_stl_format = '[%E{Error 1/%e: line %fe}%B{, }%W{Warning 1/%w: line %fw}]'
  "let g:syntastic_jsl_conf = '$HOME/.vim/jsl.conf'
  let g:syntastic_check_on_open=1
  let g:syntastic_warning_symbol = '⚠'

  let g:syntastic_objc_compiler = 'clang'
  let g:syntastic_objc_compiler_options = '-std=gnu99 -fmodules'

  call neobundle#untap()
endif "}}}
if neobundle#tap('tagbar') "{{{
  let g:tagbar_usearrows = 1

  nnoremap <F6> :TagbarToggle<CR>

  call neobundle#untap()
endif "}}}
if neobundle#tap('ultisnips') "{{{
  let g:UltiSnipsExpandTrigger="<tab>"
  let g:UltiSnipsJumpForwardTrigger="<tab>"
  let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

  call neobundle#untap()
endif "}}}
if neobundle#tap('unite.vim') "{{{
  function! neobundle#hooks.on_source(bundle)
    call unite#custom#profile('default', 'context', {
          \ 'direction': 'botright'
          \ })
  endfunction
endif "}}}
if neobundle#tap('vim-airline') "{{{
  let g:airline_powerline_fonts = 1
  let g:airline#extensions#tabline#enabled = 1
  let g:airline#extensions#tabline#left_sep=' '
  let g:airline#extensions#tabline#left_alt_sep='¦'

  function! neobundle#hooks.on_source(bundle)
    call airline#parts#define_text('bomb', 'BOM')
    call airline#parts#define_condition('bomb', '&bomb')
    call airline#parts#define_accent('bomb', 'bold')

    function! s:AirlineInit()
      let g:airline_section_y = airline#section#create_right(['bomb', 'ffenc'])
    endfunction
    autocmd VimEnter * call s:AirlineInit()
  endfunction

  call neobundle#untap()
endif "}}}
if neobundle#tap('vim-fugitive') "{{{
  nnoremap <leader>Gd :Gdiff<CR>
  nnoremap <leader>Gs :Gstatus<CR>
  nnoremap <leader>Gw :Gwrite<CR>
  nnoremap <leader>Ga :Gadd<CR>
  nnoremap <leader>Gb :Gblame<CR>
  nnoremap <leader>Gco :Gcheckout<CR>
  nnoremap <leader>Gci :Gcommit<CR>
  nnoremap <leader>Gm :Gmove<CR>
  nnoremap <leader>Gr :Gremove<CR>
  nnoremap <leader>Gl :Glog<CR>

  augroup ft_fugitive
    au!

    au BufNewFile,BufRead .git/index setlocal nolist
    au BufReadPost fugitive://* set bufhidden=delete
  augroup END

  call neobundle#untap()
endif "}}}
if neobundle#tap('vim-signify') "{{{
  let g:signify_update_on_bufenter=0
  let g:signify_update_on_focusgained=1
  let g:signify_vcs_list = ['git']
endif "}}}
if neobundle#tap('vimfiler') "{{{
  noremap  <F2> :VimFilerExplorer<CR>
  inoremap <F2> <ESC>:VimFilerExplorer<CR>

  let g:vimfiler_as_default_explorer = 1
  let g:vimfiler_tree_leaf_icon = '꞉'
  let g:vimfiler_tree_opened_icon = '▼'
  let g:vimfiler_tree_closed_icon = '▷'
  let g:vimfiler_readonly_file_icon = ''
  let g:vimfiler_ignore_pattern = '^\.\|\.\%(pyc\|o\)$\|.\~\|Icon\r$'

  function! neobundle#hooks.on_post_source(bundle)
    if system("uname") =~? '^darwin'
      let g:vimfiler_quick_look_command = 'qlmanage -p'
    endif

    augroup plug_vimfiler
      au!
      autocmd FileType vimfiler call s:vimfiler_settings()
    augroup END
    function! s:vimfiler_settings()
      setlocal nonumber

      nunmap <buffer> <C-J>
      nunmap <buffer> <C-L>
      nmap <buffer> <C-R> <Plug>(vimfiler_redraw_screen)
      nmap <buffer> <C-Q> <Plug>(vimfiler_quick_look)
      nmap <buffer> <C-E> <Plug>(vimfiler_switch_to_history_directory)
    endfunction

    if &filetype == 'vimfiler'
      call s:vimfiler_settings()
    endif
  endfunction

  call neobundle#untap()
endif "}}}

call neobundle#end()

" }}}

" }}}
" Basic Options {{{

set encoding=utf-8
set modeline
set modelines=5
set autoindent
set smartindent
set showmode
set showcmd
set hidden
set ruler
set backspace=indent,eol,start
set laststatus=2
set history=1000
set list
set listchars=tab:\|\ ,trail:.,extends:❯,precedes:❮
set shell=/bin/bash
set lazyredraw
set matchtime=3
set splitbelow
set splitright
set fillchars=diff:⣿
set timeout
set noautowrite
set shiftround
set autoread
set title
set dictionary=/usr/share/dict/words
set confirm
set fileformats=unix,mac,dos
set grepprg=grep\ -nH\ $*
set showfulltag
set whichwrap+=<,>,[,]
set nojoinspaces

" Keep a large viminfo file
set viminfo='1000,f1,:1000,/1000,r/tmp,r/Volumes

" Spell-checking
set spelllang=en_us
"set spell

" Use a narrower number column if possible
if v:version >= 700
  try
    set numberwidth=3
  catch
  endtry
endif

" GUI Options {{{

if has('gui_running')

  " I want cursorline but it interferes with proper display of trail
  " because trail won't be highlighted any differently than the cursorline
  "set cursorline

  set guifont=Menlo\ for\ Powerline:h11,Menlo:h11

  " Remove all the UI cruft
  set guioptions+=c
  set guioptions-=T
  set guioptions-=l
  "set guioptions-=L
  "set guioptions-=r
  "set guioptions-=R

  " My shell setup defines a bunch of $LESS_TERMCAP_* variables to change how
  " some stuff is displayed. We don't want that in GUI Vim because we don't
  " want :! to have them.
  let $LESS_TERMCAP_mb=''
  let $LESS_TERMCAP_md=''
  let $LESS_TERMCAP_me=''
  let $LESS_TERMCAP_us=''
  let $LESS_TERMCAP_ue=''
  let $LESS_TERMCAP_so=''
  let $LESS_TERMCAP_se=''
  " It also defines $LESS, which we don't want
  let $LESS=''

  " $EDITOR tries to send focus back to Terminal.app, but if we use it from
  " GVim, we aren't using Terminal.app
  let $EDITOR='mvim -f'

  highlight SpellBad term=underline gui=undercurl guisp=Orange

  " Use a line-drawing char for pretty vertical splits
  set fillchars+=vert:│

  " Different cursors for different modes.
  set guicursor=n-c:block-Cursor-blinkon0
  set guicursor+=v:block-vCursor-blinkon0
  " Note: original used iCursor but I have no highlight for that
  set guicursor+=i-ci:ver20-Cursor/lCursor

  if has("gui_macvim")
    " Full screen means FULL screen
    set fuoptions=maxvert,maxhorz

    " Use the normal HIG movements, except for M-Up/Down
    let macvim_skip_cmd_opt_movement = 1
    no   <D-Left>       <Home>
    no!  <D-Left>       <Home>
    no   <M-Left>       <C-Left>
    no!  <M-Left>       <C-Left>

    no   <D-Right>      <End>
    no!  <D-Right>      <End>
    no   <M-Right>      <C-Right>
    no!  <M-Right>      <C-Right>

    no   <D-Up>         <C-Home>
    ino  <D-Up>         <C-Home>
    imap <M-Up>         <C-o>{

    no   <D-Down>       <C-End>
    ino  <D-Down>       <C-End>
    imap <M-Down>       <C-o>}

    no! <M-BS>          <C-w>
    no! <D-BS>          <C-u>
  else
    " Non-MacVim GUI, like Gvim
  end
endif

" }}}
" Terminal Options {{{

if !has('gui_running')
  if &term =~ "xterm-256color" || &term =~ "screen"
    set t_Co=256
    let &t_AB="\<Esc>[48;5;%dm"
    let &t_AF="\<Esc>[38;5;%dm"
  else
    set t_Co=16
  endif
endif

" }}}
" Wildmenu completion {{{

set wildmenu
set wildmode=full

set wildignore+=.hg,.git,.svn                    " Version control
set wildignore+=*.aux,*.out                      " LaTeX intermediate files
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.spl                            " compiled spelling word lists
set wildignore+=*.sw?                            " Vim swap files
set wildignore+=.DS_Store                        " OS X
set wildignore+=*.luac                           " Lua byte code
set wildignore+=*.pyc                            " Python byte code

" }}}
" Window Management {{{

augroup vimrc
  " Resize splits when the window is resized
  au VimResized * exe "normal! \<c-w>="
augroup END

" }}}
" Tabs, spaces, wrapping {{{

set tabstop=4
set shiftwidth=4
set softtabstop=-1
set expandtab
set wrap
set formatoptions=tcrql
set colorcolumn=+1

" }}}
" Backups {{{

set undodir=~/.vim/tmp/undo//
set backupdir=~/.vim/tmp/backup//
set directory=~/.vim/tmp/swap//
set nobackup
set writebackup
set backupskip+=/private/tmp/*
" Skip backups of Git files
set backupskip+=*.git/COMMIT_EDITMSG,*.git/MERGE_MSG,*.git/TAG_EDITMSG
set backupskip+=*.git/modules/*/COMMIT_EDITMSG,*.git/modules/*/MERGE_MSG
set backupskip+=*.git/modules/*/TAG_EDITMSG,git-rebase-todo
" Skip backups of SVN commit files
set backupskip+=svn-commit*.tmp

" }}}
" Color Scheme {{{

set background=dark
if has('gui_running')
    colorscheme solarized
else
    colorscheme darkblue
endif

" Highlight VCS conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)?$'

" }}}

" }}}
" Searching And Movement {{{

set ignorecase
set smartcase
set nogdefault

set scrolloff=3
set sidescroll=1
set sidescrolloff=10

set virtualedit+=block

runtime macros/matchit.vim

" Heresy
inoremap <c-a> <esc>I
inoremap <c-e> <esc>A

" Open a Quickfix window for the last search
nnoremap <silent> <leader>/ :execute 'vimgrep /'.@/.'/g %'<CR>:copen<CR>

" Ack for the last search
nnoremap <silent> <leader>? :execute "Ack! '" . substitute(substitute(substitute(@/, "\\\\<", "\\\\b", ""), "\\\\>", "\\\\b", ""), "\\\\v", "", "") . "'"<CR>

" Search Highlighting {{{

set hlsearch
set incsearch

nnoremap <silent> <C-[>u :nohlsearch<CR>

" }}}
" Error Navigation {{{

"             Location List     QuickFix Window
"            (e.g. Syntastic)     (e.g. Ack)
"            ----------------------------------
" Next      |     M-j               M-Down     |
" Previous  |     M-k                M-Up      |
"            ----------------------------------

nnoremap ∆ :lnext<cr>zvzz
nnoremap ˚ :lprevious<cr>zvzz
nnoremap <m-Down> :cnext<cr>zvzz
nnoremap <m-Up> :cprevious<cr>zvzz

" }}}
" Directional Keys {{{

" It's 2011
noremap j gj
noremap k gk
noremap gj j
noremap gk k

" Easy buffer navigation
noremap <C-h>  <C-w>h
noremap <C-j>  <C-w>j
noremap <C-k>  <C-w>k
noremap <C-l>  <C-w>l

" }}}
" Highlight Word {{{

nnoremap <silent> <leader>hh :match InterestingWord1  /\<<c-r><c-w>\>/<cr>
nnoremap <silent> <leader>h1 :match InterestingWord1  /\<<c-r><c-w>\>/<cr>
nnoremap <silent> <leader>h2 :2match InterestingWord2 /\<<c-r><c-w>\>/<cr>
nnoremap <silent> <leader>h3 :3match InterestingWord3 /\<<c-r><c-w>\>/<cr>

nnoremap <silent> <leader>hn  :match  none<cr>
nnoremap <silent> <leader>hn1 :match  none<cr>
nnoremap <silent> <leader>hn2 :2match none<cr>
nnoremap <silent> <leader>hn3 :3match none<cr>

hi def InterestingWord1 ctermbg=green guibg=green ctermfg=black guifg=#000000
hi def InterestingWord2 ctermbg=blue  guibg=blue  ctermfg=black guifg=#000000
hi def InterestingWord3 ctermbg=red   guibg=red   ctermfg=white guifg=#FFFFFF

" }}}
" Visual Mode */# From Scrooloose {{{

function! s:VSetSearch()
  let temp = @@
  norm! gvy
  let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
  let @@ = temp
endfunction

vnoremap * :<C-u>call <SID>VSetSearch()<CR>//<CR><c-o>
vnoremap # :<C-u>call <SID>VSetSearch()<CR>??<CR><c-o>

" }}}

" }}}
" Folding {{{

set foldenable

set foldlevelstart=-1

set foldcolumn=1

" Use ,z to "focus" the current fold
nnoremap <leader>z zMzvzz

function! MyFoldText(foldstart, foldend) " {{{
  let line = getline(a:foldstart)

  let foldedlinecount = a:foldend - a:foldstart + 1

  " expand tabs into spaces
  while 1
    let idx = stridx(line, "\t")
    if idx == -1
      break
    endif
    let width = strdisplaywidth("\t", idx)
    let line = strpart(line, 0, idx) . repeat(" ", width) . line[idx+1:]
  endwhile

  " get window width
  " this is pretty hacky, but unfortunately the only way to get the
  " definitive window width involves moving the cursor and that kind of
  " sucks.
  let nucolwidth = &fdc + &number * &numberwidth
  let windowwidth = winwidth(0) - nucolwidth - 3
  if has('signs')
    redir => signs
      silent execute 'sign place buffer=' . bufnr('')
    redir END
    if signs =~# '='
      " at least one sign is defind, there must be a gutter
      let windowwidth -= 2
    endif
  endif

  let maxwidth = windowwidth - strwidth(foldedlinecount) - 2
  let line = line[:maxwidth]
  let fillcharcount = maxwidth - strwidth(line)
  return line . '…' . repeat(" ",fillcharcount) . foldedlinecount . '…' . ' '
endfunction " }}}
set foldtext=MyFoldText(v:foldstart,v:foldend)

" Always ensure current fold is visible when opening a file
au BufEnter * normal zv

" }}}
" Destroy Infuriating Keys {{{

" Fuck you, help key.
noremap  <F1> :set invfullscreen<CR>
inoremap <F1> <ESC>:set invfullscreen<CR>

" }}}
" Filetype Settings {{{

" C {{{

augroup ft_c
  au!
  au FileType c setlocal foldmethod=syntax
augroup END

" }}}
" Clojure {{{

let g:slimv_leader = '\'
let g:slimv_keybindings = 2

augroup ft_clojure
  au!

  au FileType clojure call TurnOnClojureFolding()
  "au FileType clojure compiler clojure
  au FileType clojure setlocal report=100000
  au FileType clojure nnoremap <buffer> o jI<cr><esc>kA
  au FileType clojure nnoremap <buffer> O I<cr><esc>kA

  au BufWinEnter        Slimv.REPL.clj setlocal winfixwidth
  au BufNewFile,BufRead Slimv.REPL.clj setlocal nowrap
  au BufNewFile,BufRead Slimv.REPL.clj setlocal foldlevel=00
  au BufNewFile,BufRead Slimv.REPL.clj nnoremap <buffer> A GA
  au BufNewFile,BufRead Slimv.REPL.clj nnoremap <buffer> <localleader>R :emenu REPL.<Tab>

  " Fix the eval mapping.
  au FileType clojure nmap <buffer> \ee \ed

  " Indent top-level form.
  au FileType clojure nmap <buffer> <localleader>= v((((((((((((=%

  " Use a swank command that works, and doesn't require new app windows.
  au FileType clojure let g:slimv_swank_cmd='!dtach -n /tmp/dtach-swank.sock -r winch lein swank'
augroup END

" }}}
" Confluence {{{

augroup ft_c
  au!

  au BufRead,BufNewFile *.confluencewiki setlocal filetype=confluencewiki

  " Wiki pages should be soft-wrapped.
  au FileType confluencewiki setlocal wrap linebreak nolist
augroup END

" }}}
" Cram {{{

let cram_fold=1

augroup ft_cram
  au!

  au BufNewFile,BufRead *.t set filetype=cram
  au Syntax cram setlocal foldlevel=1
augroup END

" }}}
" CSS and LessCSS {{{

augroup ft_css
  au!

  au BufNewFile,BufRead *.less setlocal filetype=less

  au Filetype less,css setlocal foldmethod=marker
  au Filetype less,css setlocal foldmarker={,}
  au Filetype less,css setlocal omnifunc=csscomplete#CompleteCSS
  au Filetype less,css setlocal iskeyword+=-

  " Use <leader>S to sort properties.  Turns this:
  "
  "     p {
  "         width: 200px;
  "         height: 100px;
  "         background: red;
  "
  "         ...
  "     }
  "
  " into this:
  "
  "     p {
  "         background: red;
  "         height: 100px;
  "         width: 200px;
  "
  "         ...
  "     }
  au BufNewFile,BufRead *.less,*.css nnoremap <buffer> <localleader>S ?{<CR>jV/\v^\s*\}?$<CR>k:sort<CR>:noh<CR>

  " Make {<cr> insert a pair of brackets in such a way that the cursor is correctly
  " positioned inside of them AND the following code doesn't get unfolded.
  au BufNewFile,BufRead *.less,*.css inoremap <buffer> {<cr> {}<left><cr><space><space><space><space>.<cr><esc>kA<bs>
augroup END

" }}}
" Django {{{

augroup ft_django
  au!

  au BufNewFile,BufRead urls.py           setlocal nowrap
  au BufNewFile,BufRead urls.py           normal! zR
  au BufNewFile,BufRead dashboard.py      normal! zR
  au BufNewFile,BufRead local_settings.py normal! zR

  au BufNewFile,BufRead admin.py     setlocal filetype=python.django
  au BufNewFile,BufRead urls.py      setlocal filetype-python.django
  au BufNewFile,BufRead models.py    setlocal filetype=python.django
  au BufNewFile,BufRead views.py     setlocal filetype=python.django
  au BufNewFile,BufRead settings.py  setlocal filetype=python.django
  au BufNewFile,BufRead settings.py  setlocal foldmethod=marker
  au BufNewFile,BufRead forms.py     setlocal filetype.python.django
  au BufNewFile,BufRead common_settings.py  setlocal filetype=python.django
  au BufNewFile,BufRead common_settings.py  setlocal foldmethod=marker
augroup END

" }}}
" Firefox {{{

augroup ft_firefox
  au!
  au BufRead,BufNewFile ~/Library/Caches/*.html setlocal buftype=nofile
augroup END

" }}}
" HTML and HTMLDjango {{{

augroup ft_html
  au!

  au BufNewFile,BufRead *.html setlocal filetype=htmldjango
  au FileType html,jinja,htmldjango setlocal foldmethod=manual

  " Use <localleader>f to fold the current tag.
  au FileType html,jinja,htmldjango nnoremap <buffer> <localleader>f Vatzf

  " Use Shift-Return to turn this:
  "     <tag>|</tag>
  "
  " into this:
  "     <tag>
  "         |
  "     </tag>
  au FileType html,jinja,htmldjango nnoremap <buffer> <s-cr> vit<esc>a<cr><esc>vito<esc>i<cr><esc>

  " Smarter pasting
  "au FileType html,jinja,htmldjango nnoremap <buffer> p :<C-U>YRPaste 'p'<CR>v`]=`]
  "au FileType html,jinja,htmldjango nnoremap <buffer> P :<C-U>YRPaste 'P'<CR>v`]=`]
  "au FileType html,jinja,htmldjango nnoremap <buffer> π :<C-U>YRPaste 'p'<CR>
  "au FileType html,jinja,htmldjango nnoremap <buffer> ∏ :<C-U>YRPaste 'P'<CR>

  " Django tags
  au FileType jinja,htmldjango inoremap <buffer> <c-t> {%<space><space>%}<left><left><left>

  " Django variables
  au FileType jinja,htmldjango inoremap <buffer> <c-f> {{<space><space>}}<left><left><left>
augroup END

" }}}
" Java {{{

augroup ft_java
  au!

  au FileType java setlocal foldmethod=marker
  au FileType java setlocal foldmarker={,}
augroup END

" }}}
" Javascript {{{

augroup ft_javascript
  au!

  au FileType javascript setlocal foldmethod=marker
  au FileType javascript setlocal foldmarker={,}
augroup END

" }}}
" Lisp {{{

let g:lisp_rainbow = 1

augroup ft_lisp
  au!
  au FileType lisp call TurnOnLispFolding()
augroup END

" }}}
" Markdown {{{

let g:markdown_fenced_languages = ['rust', 'objc', 'swift']

augroup ft_markdown
  au!

  " Use <localleader>1/2/3 to add headings.
  au Filetype markdown nnoremap <buffer> <localleader>1 yypVr=
  au Filetype markdown nnoremap <buffer> <localleader>2 yypVr-
  au Filetype markdown nnoremap <buffer> <localleader>3 I### <ESC>
augroup END

" }}}
" Nginx {{{

augroup ft_nginx
  au!

  au BufNewFile,BufRead /etc/nginx/conf/*                      set ft=nginx
  au BufNewFile,BufRead /etc/nginx/sites-available/*           set ft=nginx
  au BufNewFile,BufRead /usr/local/etc/nginx/sites-avaialble/* set ft=nginx
  au BufNewFile,BufRead vhost.ngingx                           set ft=nginx

  au FileType nginx setlocal foldmethod=marker foldmarker={,}
augroup END

" }}}
" OrgMode {{{

augroup ft_org
  au!

  au Filetype org nmap <buffer> Q vahjgq
augroup END

" }}}
" Pentadactyl {{{

augroup ft_pentadactyl
  au!

  au BufNewFile,BufRead .pentadactylrc set filetype=pentadactyl
  au BufNewFile,BufRead ~/Library/Caches/TemporaryItems/pentadactyl-*.tmp set nolist wrap linebreak columns=100 colorcolumn=0
augroup END

" }}}
" Perl {{{

let g:perl_include_pod=1
let g:perl_fold=1
let g:perl_fold_blocks=1

" }}}
" Puppet {{{

augroup ft_puppet
  au!

  au Filetype puppet setlocal foldmethod=marker
  au Filetype puppet setlocal foldmarker={,}
augroup END

" }}}
" Python {{{

augroup ft_python
  au!

  "au FileType python noremap  <buffer> <localleader>rr :RopeRename<CR>
  "au FileType python vnoremap <buffer> <localleader>rm :RopeExtractMethod<CR>
  "au FileType python noremap  <buffer> <localleader>ri :RopeOrganizeImports<CR>

  au FileType python setlocal omnifunc=pythoncomplete#Complete
  au FileType python setlocal define=^\s*\\(def\\\\|class\\)
  "au FileType python compiler nose
  au FileType man nnoremap <buffer> <cr> :q<cr>
augroup END

" }}}
" QuickFix {{{

augroup ft_quickfix
  au!
  au FileType qf setlocal colorcolumn=0 nolist nocursorline nowrap
augroup END

" }}}
" ReStructuredText {{{

augroup ft_rest
  au!

  au FileType rst nnoremap <buffer> <localleader>1 yypVr=
  au FileType rst nnoremap <buffer> <localleader>2 yypVr-
  au FileType rst nnoremap <buffer> <localleader>3 yypVr~
  au FileType rst nnoremap <buffer> <localleader>4 yypVr`
augroup END

" }}}
" Ruby {{{

augroup ft_ruby
  au!
  au FileType ruby setlocal foldmethod=syntax
augroup END

" }}}
" Rust {{{

let g:rust_conceal=1
let g:rust_colorcolumn=1
let g:rust_fold=1
augroup ft_rust
  au!
  au FileType rust command! -buffer ReloadRust call <SID>ReloadRust()
augroup END

function! s:ReloadRust()
  unlet b:did_indent
  delf GetRustIndent
  runtime indent/rust.vim
  set filetype=
  set filetype=rust
  runtime autoload/rust.vim
endfunction

let g:tagbar_type_rust = {
  \ 'ctagstype' : 'rust',
  \ 'kinds'     : [
    \ 'f:function',
    \ 'T:types',
    \ 'm:types',
    \ 'm:modules',
    \ 'm:consts',
    \ 'm:traits',
    \ 'm:impls',
    \ 'm:macros'
  \ ],
  \ 'sro'      : '::'
\ }

" }}}
" Vagrant {{{

augroup ft_vagrant
  au!
  au BufNewFile,BufRead Vagrantfile set ft=ruby
augroup END

" }}}
" Vim {{{

augroup ft_vim
  au!

  au FileType vim setlocal foldmethod=marker
  "au FileType help setlocal textwidth=78
augroup END

" }}}
" Vim Help {{{

function! s:AdjustHelpSplit()
  if exists('w:adjust_help_split')
    " this window has already had a buffer in it
    return
  endif
  let w:adjust_help_split=1

  if &buftype == 'help'
    " help buffer entering a brand new window.
    let l:lastwin = winnr('#')
    if l:lastwin == 0
      " no previous window? this must be on a new tab page. Ignore it.
      return
    endif
    if l:lastwin != winnr()-1
      " the last window is not above / to the left
      return
    endif

    exe l:lastwin . 'wincmd w'
    wincmd x
  endif
endfunction

augroup ft_help
  au!

  " Make <Return> behave like <C-]> (jump to tag)
  au FileType help nmap <buffer> <Return> <C-]>

  " Help splits should go above even if splitbelow is set
  au BufWinEnter * call s:AdjustHelpSplit()
augroup END

" }}}

" }}}
" Quick Editing {{{

nnoremap <leader>ev <C-w>s<C-w>j<C-w>L:e $MYVIMRC<cr>
nnoremap <leader>es <C-w>s<C-w>j<C-w>L:e ~/.vim/UltiSnips/<cr>

" }}}
" Shell {{{

function! s:ExecuteInShell(command) " {{{
  let command = join(map(split(a:command), 'expand(v:val)'))
  let winnr = bufwinnr('^' . command . '$')
  silent! execute  winnr < 0 ? 'botright vnew ' . fnameescape(command) : winnr . 'wincmd w'
  setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile nowrap nonumber
  echo 'Execute ' . command . '...'
  silent! execute 'silent %!' . command
  silent! redraw
  silent! execute 'au BufUnload <buffer> execute bufwinnr(' . bufnr('#') . ') . ''wincmd w'''
  silent! execute 'nnoremap <silent> <buffer> <LocalLeader>r :call <SID>ExecuteInShell(''' . command . ''')<CR>:AnsiEsc<CR>'
  silent! execute 'nnoremap <silent> <buffer> q :q<CR>'
  silent! execute 'AnsiEsc'
  echo 'Shell command ' . command . ' executed.'
endfunction " }}}
command! -complete=shellcmd -nargs=+ Shell call s:ExecuteInShell(<q-args>)
nnoremap <leader>! :Shell<Space>

" }}}
" Convenience Mappings {{{

" Emacs bindings in command line mode
cnoremap <c-a> <home>
cnoremap <c-e> <end>
cnoremap <c-k> <C-\>estrpart(getcmdline(),0,getcmdpos()-1)<CR>

" Faster Esc
if !&insertmode
  inoremap jk <esc>
endif

" Source
vnoremap <leader>S y:execute @@<cr>
nnoremap <leader>S ^vg_y:execute @@<cr>

" Marks and Quotes
noremap ' `
noremap æ '
noremap ` <C-^>

" Calculator
inoremap <C-B> <C-O>yiW<End>=<C-R>=<C-R>0<CR>

" Better Completion
set completeopt=longest,menuone,preview
" inoremap <expr> <CR>  pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" inoremap <expr> <C-p> pumvisible() ? '<C-n>'  : '<C-n><C-r>=pubvisible() ? "\<lt>up>" : ""<CR>'
" inoremap <expr> <C-n> pumvisible() ? '<C-n>'  : '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

" Sudo to write
cmap w!! w !sudo tee % >/dev/null

" I suck at typing.
"nnoremap <localleader>= ==
"vnoremap - =

" Toggle textwidth
nnoremap <F8> :if &tw == 0 \| set tw=78 \| else \| set tw=0 \| endif<CR>

" Toggle paste
set pastetoggle=<F8>

" Handle URL {{{
" Stolen from https://github.com/askedrelic/homedir/blob/master/.vimrc
" OSX only: Open a web-browser with the URL in the current line
function! HandleURI()
  let s:uri = matchstr(getline("."), '[a-z]*:\/\/[^ >,;]*')
  echo s:uri
  if s:uri != ""
    exec "!open " . shellescape(s:uri)
  else
    echo "No URI found in line."
  endif
endfunction
map <leader>u :call HandleURI()<CR>
" }}}

" Quickreturn
inoremap <c-cr> <esc>A<cr>

" Block Colors {{{

function! s:InitBlockColor() abort " {{{
  let s:blockcolor_count = 20
  let s:blockcolor_state = 0
  let s:blockcolor_matchid = 77880

  function! s:ToggleBlockColor() " {{{
    if s:blockcolor_state
      let s:blockcolor_state = 0
      for l:idx in range(s:blockcolor_count)
        call matchdelete(s:blockcolor_matchid+l:idx)
      endfor
    else
      let s:blockcolor_state = 1
      for l:idx in range(s:blockcolor_count)
        " hard tabs match the virtual column of their start, not their
        " end. This makes things a little more complicated.
        " Instead of searching up to the shiftwidth, we instead want
        " to locate the first indent character that's greater than the
        " previous indentation level, and which is followed by
        " anything greater than the current indentation level.
        if l:idx == 0
          " First indentation level is the trivial case
          let l:pat = '^\s'
        else
          let l:pat = printf('^\s*\zs\%%>%dv\s\%%>%dv',
                \ l:idx * &sw - &sw,
                \ l:idx * &sw + 1)
        endif
        let l:pat .= '.*'
        call matchadd("BlockColor".l:idx, l:pat, -100 + l:idx,
              \ s:blockcolor_matchid+l:idx)
      endfor
    endif
  endfunction " }}}

  for l:idx in range(s:blockcolor_count)
    let l:termbg = 234 + min([l:idx, 10])
    let l:bgcomp = 0x22 + (l:idx * 2)
    let l:guibg = printf("#%02x%02x%02x", l:bgcomp, l:bgcomp, l:bgcomp)
    execute printf('hi def BlockColor%d guibg=%s ctermbg=%d', l:idx,
          \ l:guibg, l:termbg)
  endfor

  nnoremap <leader>B :call <SID>ToggleBlockColor()<CR>
endfunction " }}}

call s:InitBlockColor()

" }}}

" use ,r to toggle relative line numbers
function! s:ToggleNuMode()
  if !&nu
    set nu
  endif
  set rnu!
endfunction
nnoremap <silent> <leader>r :call <SID>ToggleNuMode()<cr>
vnoremap <silent> <leader>r :<C-U>call <SID>ToggleNuMode()<cr>gv

" Redraw the screen with ,l
nnoremap <silent> <leader>l <C-L>
vnoremap <silent> <leader>l :<C-U>normal! <C-L><CR>gv

" Bind ,gq to reformat without textwidth. This is intended for formatting
" comments at the normal 79 when the ftplugin sets a longer textwidth.
function! s:ReformatComments(type, ...)
  let save_tw = &l:tw
  setl tw=0

  if a:0 " Invoked from Visual mode
    silent exe 'normal! `<' . a:type . '`>gq'
  elseif a:type == 'line'
    silent exe "normal! '[V']gq"
  elseif a:type == 'block'
    silent exe "normal! `[\<C-V>`]gq"
  else
    silent exe "normal! `[v`]gq"
  endif

  let &l:tw = save_tw
endfunction
nnoremap <silent> <leader>gq :set opfunc=<SID>ReformatComments<CR>g@
vnoremap <silent> <leader>gq :<C-U>call <SID>ReformatComments(visualmode(), 1)<CR>

" }}}
" Text Objects {{{

" Shortcut for [] {{{

onoremap id i[
onoremap ad a[
vnoremap id i[
vnoremap ad a[

" }}}
" Next and Last {{{

" Motion for "next/last object". For example, "din(" would go to the next "()" pair
" and delete its contents.

onoremap an :<c-u>call <SID>NextTextObject('a', 'f')<cr>
xnoremap an :<c-u>call <SID>NextTextObject('a', 'f')<cr>
onoremap in :<c-u>call <SID>NextTextObject('i', 'f')<cr>
xnoremap in :<c-u>call <SID>NextTextObject('i', 'f')<cr>

onoremap al :<c-u>call <SID>NextTextObject('a', 'F')<cr>
xnoremap al :<c-u>call <SID>NextTextObject('a', 'F')<cr>
onoremap il :<c-u>call <SID>NextTextObject('i', 'F')<cr>
xnoremap il :<c-u>call <SID>NextTextObject('i' ,'F')<cr>

function! s:NextTextObject(motion, dir)
  let c = nr2char(getchar())

  if c ==# "b"
    let c = "("
  elseif c ==# "B"
    let c = "{"
  elseif c ==# "d"
    let c = "["
  endif

  exe "normal! ".a:dir.c."v".a:motion.c
endfunction

" }}}

" }}}
" Ack Motions {{{

" Motions to Ack for things.  Works with pretty much everything, including:
"
"   w, W, e, E, b, B, t*, f*, i*, a*, and custom text objects
"
" Awesome.
"
" Note: if the text covered by a motion contains a newline it won't work.  Ack
" searches line-by-line.

nnoremap <silent> <leader>a :set opfunc=<SID>AckMotion<CR>g@
xnoremap <silent> <leader>a :<C-U>call <SID>AckMotion(visualmode())<CR>

function! s:CopyMotionForType(type)
  if a:type ==# 'v'
    silent execute "normal! `<" . a:type . "`>y"
  elseif a:type ==# 'char'
    silent execute "normal! `[v`]y"
  endif
endfunction

function! s:AckMotion(type) abort
  let reg_save = @@

  call s:CopyMotionForType(a:type)

  execute "normal! :Ack! --literal " . shellescape(@@) . "\<cr>"

  let @@ = reg_save
endfunction

" }}}
" Utilities {{{

" Synstack {{{

" Show the stack of syntax highlighting classes affecting whatever is under the
" cursor.
function! s:SynStack() "{{{{
  let syns = map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
  let trans = synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
  let res = join(syns, ' > ')
  if !empty(syns) && syns[-1] != trans
    let res .= ' (' . trans . ')'
  endif
  if empty(res)
    let res = 'No syntax items!'
  endif
  echo res
endfunc "}}}

nnoremap ß :call <SID>SynStack()<CR>

" }}}
" Toggle whitespace in diffs {{{

set diffopt-=iwhite
let g:diffwhitespaceon = 1
function! ToggleDiffWhitespace() "{{{
  if g:diffwhitespaceon
    set diffopt-=iwhite
    let g:diffwhitespaceon = 0
  else
    set diffopt+=iwhite
    let g:diffwhitespaceon = 1
  endif
  diffupdate
endfunc "}}}

nnoremap <leader>dw :call ToggleDiffWhitespace()<CR>

" }}}
" Tidy XML/XHTML {{{
function! Tidy() " {{{
  if &filetype == "xml" || &filetype == "xhtml"
    silent %!xmllint --format --recover - 2>/dev/null
  else
    echo "Unknown filetype"
  endif
endfunc "}}}

command! Tidy :call Tidy()

" }}}

" }}}
" Nyan! {{{

function! NyanMe() " {{{
  hi NyanFur             guifg=#BBBBBB
  hi NyanPoptartEdge     guifg=#ffd0ac
  hi NyanPoptartFrosting guifg=#fd3699 guibg=#fe98ff
  hi NyanRainbow1        guifg=#6831f8
  hi NyanRainbow2        guifg=#0099fc
  hi NyanRainbow3        guifg=#3cfa04
  hi NyanRainbow4        guifg=#fdfe00
  hi NyanRainbow5        guifg=#fc9d00
  hi NyanRainbow6        guifg=#fe0000

  echohl NyanRainbow1
  echon "≈"
  echohl NyanRainbow2
  echon "≋"
  echohl NyanRainbow3
  echon "≈"
  echohl NyanRainbow4
  echon "≋"
  echohl NyanRainbow5
  echon "≈"
  echohl NyanRainbow6
  echon "≋"
  echohl NyanRainbow1
  echon "≈"
  echohl NyanRainbow2
  echon "≋"
  echohl NyanRainbow3
  echon "≈"
  echohl NyanRainbow4
  echon "≋"
  echohl NyanRainbow5
  echon "≈"
  echohl NyanRainbow6
  echon "≋"
  echohl None
  echo ""

  echohl NyanRainbow1
  echon "≈"
  echohl NyanRainbow2
  echon "≋"
  echohl NyanRainbow3
  echon "≈"
  echohl NyanRainbow4
  echon "≋"
  echohl NyanRainbow5
  echon "≈"
  echohl NyanRainbow6
  echon "≋"
  echohl NyanRainbow1
  echon "≈"
  echohl NyanRainbow2
  echon "≋"
  echohl NyanRainbow3
  echon "≈"
  echohl NyanRainbow4
  echon "≋"
  echohl NyanRainbow5
  echon "≈"
  echohl NyanRainbow6
  echon "≋"
  echohl NyanFur
  echon "╰"
  echohl NyanPoptartEdge
  echon "⟨"
  echohl NyanPoptartFrosting
  echon "⣮⣯⡿"
  echohl NyanPoptartEdge
  echon "⟩"
  echohl NyanFur
  echon "⩾^ω^⩽"
  echohl None
  echo ""

  echohl NyanRainbow1
  echon "≈"
  echohl NyanRainbow2
  echon "≋"
  echohl NyanRainbow3
  echon "≈"
  echohl NyanRainbow4
  echon "≋"
  echohl NyanRainbow5
  echon "≈"
  echohl NyanRainbow6
  echon "≋"
  echohl NyanRainbow1
  echon "≈"
  echohl NyanRainbow2
  echon "≋"
  echohl NyanRainbow3
  echon "≈"
  echohl NyanRainbow4
  echon "≋"
  echohl NyanRainbow5
  echon "≈"
  echohl NyanRainbow6
  echon "≋"
  echohl None
  echon " "
  echohl NyanFur
  echon "”   ‟"
  echohl None

  sleep 1
  redraw
  echo " "
  echo " "
  echo "Noms?"
  redraw
endfunction " }}}
command! NyanMe call NyanMe()

" }}}
" Miscellaneous {{{

" This is a collection of old settings that I never migrated to the
" better-organized sections above.

" /bin/sh is bash
let is_bash = 1

" let vim know that .sit, .sitx, and .hqx are compressed files
let g:ft_ignore_pat = '\.\(Z\|gz\|bz2\|zip\|tgz\|sit\|sitx\|hqx\)$'

" Syntax when printing (whenever that is)
set popt+=syntax:y

" Commands {{{

function! s:TabMessage(cmd)
  redir => message
  silent execute a:cmd
  redir END
  tabnew
  silent put =message
  set nomodified
  1
endfunction
command! -nargs=+ -complete=command TabMessage call <SID>TabMessage(<q-args>)

function! s:ReloadFiletype()
  let old_ft = &filetype
  setf none
  " ensure all the syntax items are cleared out
  syn clear
  let &l:filetype=old_ft
endfunction

command! -bar Setf call <SID>ReloadFiletype()

" }}}
" Autocmds {{{

" If we're in a wide window, enable line numbers
function! s:WindowWidth()
  if bufname('%') != '-MiniBufExplorer-' && &buftype != 'help' && &filetype != 'unite' && &filetype != 'vimfiler'
    if winwidth(0) > 90
      setlocal number
    else
      setlocal nonumber
    endif
  endif
endfunction

augroup vimrc
  " Automagic line numbers
  autocmd VimEnter,WinEnter * :call s:WindowWidth()

  " Detect procmailrc (as if I'd ever need this)
  autocmd BufRead procmailrc :setfiletype procmail
augroup END

" }}}
" Mappings {{{

nmap <silent> <S-Left> :bprev<CR>
nmap <silent> <S-Right>  :bnext<CR>

" Delete a buffer but keep layout
command! Kwbd enew|bd #

" Annoying default mappings
inoremap <S-Up>   <C-o>gk
inoremap <S-Down> <C-o>gj
noremap  <S-Up>   gk
noremap  <S-Down> gj

" Pull the following line to the cursor position
nmap <silent> <Leader>J :call <SID>Join()<CR>
fun! <SID>Join()
  let l:c = col('.')
  let l:l = line('.')
  s/\%#\(.*\)\n\(.*\)/\2\1/e
  call cursor(l:l,l:c)
endfun

" Map space and backspace to forward/backward screen
map <space> <c-f>
map <backspace> <c-b>

" }}}
" Plugin / Script / App Settings {{{

" Settings for :TOhtml
let html_number_lines=1
let html_use_css=1
let use_xhtml=1

" }}}
" Syntax / Filetypes {{{

augroup vimrc
  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
          \ exe "normal g`\"" |
        \ endif
augroup END

" }}}

" }}}
" Postlude {{{

filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck

if !has('vim_starting')
  " Call on_source hook when reloading .vimrc
  call neobundle#call_hook('on_source')
endif

" }}}
