" vim: noet sw=4 ts=4
" Author: Kevin Ballard <kevin@sb.org>
"
" Much of these settings came from other sources.
" Including Steve Losh (https://bitbucket.org/sjl/dotfiles/src/tip/vim/vimrc)

" Preamble ----------------------------------------------------------------- {{{

filetype off
call pathogen#runtime_append_all_bundles()
filetype plugin indent on
set nocompatible

" }}}
" Basic options ------------------------------------------------------------ {{{

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
set number
set norelativenumber
set laststatus=2
set history=1000
set undofile
set undoreload=10000
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
set nohlsearch
set confirm
set fileformats=unix,mac,dos
set grepprg=grep\ -nH\ $*
set showmatch
set showfulltag
set whichwrap+=<,>,[,]

" Keep a large viminfo file
set viminfo='1000,f1,:1000,/1000,r/tmp,r/Volumes

" Spell-checking
set spelllang=en_us
"set spell

" GUI options -------------------------------------------------------------- {{{

if has('gui_running')
	" I want cursorline but it interferes with proper display of trail
	" because trail won't be highlighted any differently than the cursorline
	"set cursorline
endif

" }}}
" Terminal options --------------------------------------------------------- {{{

if !has('gui_running')
	if &term =~ "xterm-256color" || &term =~ "screen"
		set t_Co=256
		set t_AB=[48;5;%dm
		set t_AF=[38;5;%dm
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

augroup vimrc_resize
	au!

	" Resize splits when the window is resized
	au VimResized * exe "normal! \<c-w>="
augroup END

" Tabs, spaces, wrapping {{{

set tabstop=4
set shiftwidth=4
set softtabstop=0
set noexpandtab
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
set backupskip+=*.git/modules/*/COMMIT_EDITMSG,.*.git/modules/*/MERGE_MSG
set backupskip+=*.git/modules/*/TAG_EDITMSG,git-rebase-todo
" Skip backups of SVN commit files
set backupskip+=svn-commit*.tmp

" }}}
" Leader {{{

let mapleader = ","
let maplocalleader = "\\"

" }}}
" Color scheme {{{

syntax on
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
" Status line -------------------------------------------------------------- {{{

augroup ft_statuslinecolor
	au!

	" These colors are from Steve Losh's vimrc, but I'm not sure I like them
	"au InsertEnter * hi StatusLine ctermfg=196 guifg=#FF3145
	"au InsertLeave * hi StatusLine ctermfg=130 guifg=#CD5907
augroup END

fun! s:SetStatusLine()
	let l:s1="%-3.3n\\ %f\\ %h%m%r%w"
	let l:s2="[%{strlen(&filetype)?&filetype:'none'},%{&encoding},%{&fileformat}]"
	let l:s3="%{fugitive#statusline()}"
	let l:s4="%=\\ 0x%-8B\\ \\ %-14.(%l,%c%V%)\\ %<%P"
	execute "set statusline=" . l:s1 . l:s2 . l:s3 . l:s4
endfun
call s:SetStatusLine()

" Powerline ---------------------------------------------------------------- {{{

set rtp+=$HOME/Library/Python/2.7/lib/python/site-packages/powerline/bindings/vim

" }}}

" }}}
" Searching and movement --------------------------------------------------- {{{

set ignorecase
set smartcase
set incsearch
set nohlsearch
set nogdefault

set scrolloff=3
set sidescroll=1
set sidescrolloff=10

set virtualedit+=block

runtime macros/matchit.vim

" Easier to type, and I never use the default behavior.
noremap H ^
noremap L g_

" Heresy
inoremap <c-a> <esc>I
inoremap <c-e> <esc>A

" Open a Quickfix window for the last search
nnoremap <silent> <leader>/ :execute 'vimgrep /'.@/.'/g %'<CR>:copen<CR>

" Ack for the last search
nnoremap <silent> <leader>? :execute "Ack! '" . substitute(substitute(substitute(@/, "\\\\<", "\\\\b", ""), "\\\\>", "\\\\b", ""), "\\\\v", "", "") . "'"<CR>

" Fix linewise visual selection of various text objects
" Note: need to figure out what the hell these do
"nnoremap VV V
"nnoremap Vit vitVkoj
"nnoremap Vat vatV
"nnoremap Vab vabV
"nnoremap VaB vaBV

" Error navigation {{{
"
"             Location List     QuickFix Window
"            (e.g. Syntastic)     (e.g. Ack)
"            ----------------------------------
" Next      |     M-k               M-Down     |
" Previous  |     M-l                M-Up      |
"            ----------------------------------
"
nnoremap ˚ :lnext<cr>zvzz
nnoremap ¬ :lprevious<cr>zvzz
inoremap ˚ <esc>:lnext<cr>zvzz
inoremap ¬ <esc>:lprevious<cr>zvzz
nnoremap <m-Down> :cnext<cr>zvzz
nnoremap <m-Up> :cprevious<cr>zvzz
" }}}

" Directional Keys {{{

" It's 2011
noremap j gj
noremap k gk
nnoremap gj j
nnoremap gk k

" Easy buffer navigation
noremap <C-h>  <C-w>h
noremap <C-j>  <C-w>j
noremap <C-k>  <C-w>k
noremap <C-l>  <C-w>l
noremap <leader>v <C-w>v

" }}}

" Highlight word {{{
nnoremap <silent> <leader>hh :execute 'match InterestingWord1 /\<<c-r><c-w>\>/'<cr>
nnoremap <silent> <leader>h1 :execute 'match InterestingWord1 /\<<c-r><c-w>\>/'<cr>
nnoremap <silent> <leader>h2 :execute '2match InterestingWord2 /\<<c-r><c-w>\>/'<cr>
nnoremap <silent> <leader>h3 :execute '3match InterestingWord3 /\<<c-r><c-w>\>/'<cr>
" }}}

" Visual Mode */# from Scrooloose {{{
function! s:VSetSearch()
	let temp = @@
	norm! gvy
	let @/ = '\V' . substitute(excape(@@, '\'), '\n', '\\n', 'g')
	let @@ = temp
endfunction

vnoremap * :<C-u>call <SID>VSetSearch()<CR>//<CR><c-o>
vnoremap # :<C-u>call <SID>VSetSearch()<CR>??<CR><c-o>
" }}}

" }}}
" Folding ------------------------------------------------------------------ {{{

set foldenable

"set foldlevelstart=0
set foldlevelstart=-1

set foldcolumn=1

" Space to toggle folds
" Note: I think this will just confuse me
"nnoremap <Space> za
"vnoremap <Space> za

" Make zO recursively open whatever top level fold we're in, no matter where the
" cursor happens to be.
nnoremap zO zCzO

" Use ,z to "focus" the current fold
nnoremap <leader>z zMzvzz

function! MyFoldText() " {{{
	let line = getline(v:foldstart)

	let nucolwidth = &fdc + &number * &numberwidth
	let windowwidth = winwidth(0) - nucolwidth - 3
	let foldedlinecount = v:foldend - v:foldstart

	" expand tabs into spaces
	let onetab = strpart('        ', 0, &tabstop)
	let line = substitute(line, '\t', onetab, 'g')

	let line = strpart(line, 0, windowwidth - 2 - len(foldedlinecount))
	let fillcharcount = windowwidth - len(line) - len(foldedlinecount)
	return line . '…' . repeat(" ",fillcharcount) . foldedlinecount . '…' . ' '
endfunction " }}}
set foldtext=MyFoldText()

" }}}
" Destroy infuriating keys ------------------------------------------------- {{{

" Fuck you, help key.
noremap  <F1> :set invfullscreen<CR>
inoremap <F1> <ESC>:set invfullscreen<CR>a

" Fuck you too, manual key.
nnoremap K <nop>

" }}}
" Various filetype-specific stuff ------------------------------------------ {{{

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

augroup ft_lisp
	au!
	au FileType lisp call TurnOnLispFolding()
augroup END

" }}}
" Markdown {{{

let g:markdown_fenced_languages = ['rust']

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
augroup ft_rust
	au!
	au FileType rust setlocal colorcolumn=100 et fdl=99 foldmethod=syntax
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
	au BufWinEnter *.txt if &buftype == 'help' | wincmd K | endif
augroup END

" }}}

" }}}
" Quick editing ------------------------------------------------------------ {{{

nnoremap <leader>ev <C-w>s<C-w>j<C-w>L:e $MYVIMRC<cr>
nnoremap <leader>es <C-w>s<C-w>j<C-w>L:e ~/.vim/snippets/<cr>

" }}}
" Shell -------------------------------------------------------------------- {{{

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
" Convenience mappings ----------------------------------------------------- {{{

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

" Split/Join {{{
"
" Basically this splits the current line into two new ones at the cursor position,
" then joins the second one with whatever comes next.
"
" Example:                      Cursor Here
"                                    |
"                                    v
" foo = ('hello', 'world', 'a', 'b', 'c',
"        'd', 'e')
"
"            becomes
" foo = ('hello', 'world', 'a', 'b',
"        'c', 'd', 'e')
"
" Especially useful for adding items in the middle of long lists/tuples in Python
" while maintaining a sane text width.
nnoremap K h/[^ ]<cr>"zd$jyyP^v$h"zpJk:s/\v +$//<cr>:noh<cr>j^
" }}}

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

" Indent Guides {{{

let g:indentguides_state = 0
function! IndentGuides() " {{{
	if g:indentguides_state
		let g:indentguides_state = 0
		2match None
	else
		let g:indentguides_state = 1
        execute '2match IndentGuides /\%(\_^\s*\)\@<=\%(\%'.(0*&sw+1).'v\|\%'.(1*&sw+1).'v\|\%'.(2*&sw+1).'v\|\%'.(3*&sw+1).'v\|\%'.(4*&sw+1).'v\|\%'.(5*&sw+1).'v\|\%'.(6*&sw+1).'v\|\%'.(7*&sw+1).'v\)\s/'
	endif
endfunction " }}}
nnoremap <leader>i :call IndentGuides()<cr>

" }}}
" Block Colors {{{

let g:blockcolor_state = 0
function! BlockColor() " {{{
	if g:blockcolor_state
		let g:blockcolor_state = 0
		call matchdelete(77880)
		call matchdelete(77881)
		call matchdelete(77882)
		call matchdelete(77883)
	else
		let g:blockcolor_state = 1
		call matchadd("BlockColor1", '^ \{4}.*', 1, 77880)
		call matchadd("BlockColor2", '^ \{8}.*', 2, 77881)
		call matchadd("BlockColor3", '^ \{12}.*', 3, 77882)
		call matchadd("BlockColor4", '^ \{16}.*', 4, 77883)
	endif
endfunction "}}}
nnoremap <leader>B :call BlockColor()<cr>

" }}}

" use Ctrl+L to toggle relative line numbers
function! s:ToggleNuMode()
	if &nu
		set rnu
	else
		set nu
	endif
endfunction
nnoremap <script><silent> <C-L> :<C-U>call <SID>ToggleNuMode()<cr>
vnoremap <script><silent> <C-L> :<C-U>call <SID>ToggleNuMode()<cr>gv

" }}}
" Plugin settings ---------------------------------------------------------- {{{

" Ack {{{

map <leader>a :Ack!

" }}}
" ClangComplete {{{

let g:clang_library_path = "/Library/Developer/CommandLineTools/usr/lib/"
" temporarily disable the keymappings, it's interfering with delimitMate
let g:clang_make_default_keymappings = 0

" }}}
" DelimitMate {{{

let g:delimitMate_expand_cr = 1

" }}}
" Fugitive {{{

nnoremap <leader>gd :Gdiff<cr>
nnoremap <leader>gs :Gstatus<cr>
nnoremap <leader>gw :Gwrite<cr>
nnoremap <leader>ga :Gadd<cr>
nnoremap <leader>gb :Gblame<cr>
nnoremap <leader>gco :Gcheckout<cr>
nnoremap <leader>gci :Gcommit<cr>
nnoremap <leader>gm :Gmove<cr>
nnoremap <leader>gr :Gremove<cr.
nnoremap <leader>gl :Shell git gl -18<cr>:wincmd \|<cr>

augroup ft_fugitive
	au!

	au BufNewFile,BufRead .git/index setlocal nolist
augroup END

" }}}
" Gundo {{{

nnoremap <F5> :GundoToggle<CR>
let g:gundo_debug = 1
let g:gundo_preview_bottom = 1

" }}}
" Haskell {{{

let g:haddock_browser="/usr/bin/open"

" }}}
" HTML5 {{{

let g:event_handler_attributes_complete = 0
let g:rdfa_attributes_complete = 0
let g:microdata_attributes_complete = 0
let g:atia_attributes_complete = 0

" }}}
" Lisp (built-in) {{{

let g:lisp_rainbow = 1

" }}}
" NERD Commenter {{{

let g:NERDCustomDelimiters = {
            \ 'rust': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/'}
            \ }

" }}}
" NERD Tree {{{

noremap  <F2> :NERDTreeToggle<cr>
inoremap <F2> <esc>:NERDTreeToggle<cr>

augroup ft_nerdtree
	au!

	au Filetype nerdtree setlocal nolist
augroup END

let NERDTreeHighlightCursorLine=1
let NERDTreeIgnore=['.vim$', '\~$', '.*\.pyc$', 'pip-log\.txt$', 'whoosh_index', 'xapian_index', '.*\.pid', 'monitor.py', '.*-fixtures-.*.json', '.*\.o$', 'db\.db']

let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1

" }}}
" snipMate {{{

let g:snips_author = "Kevin Ballard"

" }}}
" Syntastic {{{

let g:syntastic_enable_signs = 1
let g:syntastic_disabled_filetypes = ['html']
let g:syntastic_stl_format = '[%E{Error 1/%e: line %fe}%B{, }%W{Warning 1/%w: line %fw}]'
"let g:syntastic_jsl_conf = '$HOME/.vim/jsl.conf'
let g:syntastic_check_on_open=1
let g:syntastic_warning_symbol = '⚠'

" }}}
" TagBar {{{

let g:tagbar_usearrows = 1

nnoremap <F6> :TagbarToggle<CR>

" }}}
" JsBeautify {{{

augroup plug_jsbeautify
	au!
	autocmd FileType javascript command JsBeautify :call JsBeautify()
augroup END

" }}}
" Text objects ------------------------------------------------------------- {{{

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
" Ack motions -------------------------------------------------------------- {{{

" Motions to Ack for things.  Works with pretty much everything, including:
"
"   w, W, e, E, b, B, t*, f*, i*, a*, and custom text objects
"
" Awesome.
"
" Note: if the text covered by a motion contains a newline it won't work.  Ack
" searches line-by-line.

nnoremap <silent> \a :set opfunc=<SID>AckMotion<CR>g@
xnoremap <silent> \a :<C-U>call <SID>AckMotion(visualmode())<CR>

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
" Error toggles ------------------------------------------------------------ {{{

command! ErrorsToggle call ErrorsToggle()
function! ErrorsToggle() " {{{
	if exists("w:is_error_window")
		unlet w:is_error_window
		exec "q"
	else
		exec "Errors"
		lopen
		let w:is_error_window = 1
	endif
endfunction " }}}

command! -bang -nargs=? QFixToggle call QFixToggle(<bang>0)
function! QFixToggle(forced) " {{{
	if exists("g:qfix_win") && a:forced == 0
		cclose
		unlet g:qfix_win
	else
		copen 10
		let g:qfix_win = bufnr("$")
	endif
endfunction " }}}

nmap <silent> <F3> :ErrorsToggle<cr>
nmap <silent> <F4> :QFixToggle<cr>

" }}}
" Utils -------------------------------------------------------------------- {{{

function! g:echodammit(msg)
	exec 'echom "----------> ' . a:msg . '"'
endfunction

" Synstack {{{

" Show the stack of syntax highlighting classes affecting whatever is under the
" cursor.
function! SynStack() "{{{{
	echo join(map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")'), " > ")
endfunc "}}}

nnoremap ß :call SynStack()<CR>

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
" Hg ----------------------------------------------------------------------- {{{

function! s:HgDiff()
	diffthis

	let fn = expand('%:p')
	let ft = &ft

	wincmd v
	edit __hgdiff_orig__

	setlocal buftype=nofile

	normal ggdG
	execute "silent r!hg cat --rev . " . fn
	normal ggdd

	execute "setlocal ft=" . ft

	diffthis
	diffupdate
endf
command! -nargs=0 HgDiff call s:HgDiff()
nnoremap <leader>hd :HgDiff<cr>

function! s:HgBlame()
	let fn = expand('%:p')

	wincmd v
	wincmd h
	edit __hgblame__
	vertical resize 28

	setlocal scrollbind winfixwidth nolist nowrap nonumber buftype=nofile ft=none

	normal ggdG
	execute "silent r!hg blame -undq " . fn
	normal ggdd
	execute ':%s/\v:.*$//'

	wincmd l
	setlocal scrollbind
	syncbind
endf
command! -nargs=0 HgBlame call s:HgBlame()
nnoremap <leader>hb :HgBlame<cr>

" }}}
" Environments (GUI/Console) ----------------------------------------------- {{{

if has('gui_running')
	set guifont=Menlo\ for\ Powerline:h11,Menlo:h11

	" Remove all the UI cruft
	set go-=T
	set go-=l
	"set go-=L
	"set go-=r
	"set go-=R

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

		imap <M-BS>         <C-w>
		"inoremap <D-BS>     <esc>my0c`y
		"The above definition of <D-BS> doesn't work. It won't delete
		"the last character in the line. Lets just use the default MacVim
		"definition.
		inoremap <D-BS>     <C-u>
	else
		" Non-MacVim GUI, like Gvim
	end
else
	" Console Vim
endif

" }}}
" Nyan! -------------------------------------------------------------------- {{{

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
" Pulse -------------------------------------------------------------------- {{{

function! PulseCursorLine()
    let current_window = winnr()

    windo set nocursorline
    execute current_window . 'wincmd w'

    setlocal cursorline

    redir => old_hi
        silent execute 'hi CursorLine'
    redir END
    let old_hi = split(old_hi, '\n')[0]
    let old_hi = substitute(old_hi, 'xxx', '', '')

    hi CursorLine guibg=#2a2a2a ctermbg=233
    redraw
    sleep 20m

    hi CursorLine guibg=#333333 ctermbg=235
    redraw
    sleep 20m

    hi CursorLine guibg=#3a3a3a ctermbg=237
    redraw
    sleep 20m

    hi CursorLine guibg=#444444 ctermbg=239
    redraw
    sleep 20m

    hi CursorLine guibg=#3a3a3a ctermbg=237
    redraw
    sleep 20m

    hi CursorLine guibg=#333333 ctermbg=235
    redraw
    sleep 20m

    hi CursorLine guibg=#2a2a2a ctermbg=233
    redraw
    sleep 20m

    execute 'hi ' . old_hi

    windo set cursorline
    execute current_window . 'wincmd w'
endfunction

" }}}
" }}}

" ==============================================================================

" /bin/sh is bash
let is_bash = 1

" let vim know that .sit, .sitx, and .hqx are compressed files
let g:ft_ignore_pat = '\.\(Z\|gz\|bz2\|zip\|tgz\|sit\|sitx\|hqx\)$'

" Syntax when printing (whenever that is)
set popt+=syntax:y

" Enable modelines
set modeline
set modelines=5

" If possible (i.e. in vim7) try to use a narrow number column
if v:version >= 700
	try
		setlocal numberwidth=3
	catch
	endtry
endif

"-------------------------
" commands
"-------------------------

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

"-------------------------
" autocmds
"-------------------------

" If we're in a wide window, enable line numbers
fun! <SID>WindowWidth()
	if bufname('%') != '-MiniBufExplorer-' && &buftype != 'help'
		if winwidth(0) > 90
			setlocal number
		else
			setlocal nonumber
		endif
	endif
endfun

" Force active window to the top of the screen without losing its size
fun! <SID>WindowToTop()
	let l:h=winheight(0)
	wincmd K
	execute "resize" l:h
endfun

" Force active window to the bottom of the screen without losing its size
fun! <SID>WindowToBottom()
	let l:h=winheight(0)
	wincmd J
	execute "resize" l:h
endfun

" My autocmds
augroup kevin
	autocmd!

	" Automagic line numbers
	autocmd VimEnter,WinEnter * :call <SID>WindowWidth()

	" Always do a full syntax refresh
	autocmd BufEnter * syntax sync fromstart

	" For help files, move them to the top window and make <Return>
	" behave like <C-]> (jump to tag)
	"autocmd FileType help :call <SID>WindowToTop()
	autocmd FileType help nmap <buffer> <Return> <C-]>

	" For the quickfix window, move it to the bottom
	"autocmd FileType qf :3 wincmd _ | :call <SID>WindowToBottom()

	" Detect procmailrc (as if I'd ever need this)
	autocmd BufRead procmailrc :setfiletype procmail

augroup END

"-----------------------------
" Mappings
"-----------------------------

" Find a buffer with the given number (ordering is such that the first
" entry shown in minibufexpl is 1, the second is 2 and so on). If
" there's already a window open for that buffer, switch to it. Otherwise
" switch the current window to use that buffer.
fun! <SID>SelectBuffer(wantedbufnum)
	let l:buflast = bufnr("$")
	let l:bufidx = 0
	let l:goodbufcount = 0
	while (l:bufidx < l:buflast)
		let l:bufidx = l:bufidx + 1
		if buflisted(l:bufidx)
			let l:bufname = bufname(l:bufidx)
			if (strlen(l:bufname)) &&
						\ getbufvar(l:bufidx, "&modifiable") == 1 &&
						\ l:bufname != '-MiniBufExplorer-'
				let l:goodbufcount = l:goodbufcount + 1
				if l:goodbufcount == a:wantedbufnum
					let l:winnr = bufwinnr(l:bufidx)
					if l:winnr > -1
						execute l:winnr . "wincmd w"
					else
						execute "buffer " . l:bufidx
					endif
					break
				endif
			endif
		endif
	endwhile
endfun

" Buffer switches
nmap	<silent> <M-1>	:call <SID>SelectBuffer( 1)<CR>
nmap	<silent> <M-2>	:call <SID>SelectBuffer( 2)<CR>
nmap	<silent> <M-3>	:call <SID>SelectBuffer( 3)<CR>
nmap	<silent> <M-4>	:call <SID>SelectBuffer( 4)<CR>
nmap	<silent> <M-5>	:call <SID>SelectBuffer( 5)<CR>
nmap	<silent> <M-6>	:call <SID>SelectBuffer( 6)<CR>
nmap	<silent> <M-7>	:call <SID>SelectBuffer( 7)<CR>
nmap	<silent> <M-8>	:call <SID>SelectBuffer( 8)<CR>
nmap	<silent> <M-9>	:call <SID>SelectBuffer( 9)<CR>
nmap	<silent> <M-0>	:call <SID>SelectBuffer(10)<CR>
nmap	<silent> <S-Left>	:bprev<CR>
nmap	<silent> <S-Right>	:bnext<CR>

" Delete a buffer but keep layout
command! Kwbd enew|bd #

" Annoying default mappings
inoremap	<S-Up>		<C-o>gk
inoremap	<S-Down>	<C-o>gj
noremap		<S-Up>		gk
noremap		<S-Down>	gj

" Syntax debugging
noremap <F10> :echo string(map(synstack(line("."), col(".")), 'synIDattr(v:val, "name")'))
            \ . ": " . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name")<CR>

" Insert a single char
noremap <Leader>i i<Space><Esc>r

" Append a single char
noremap <Leader>a a<Space><Esc>r

" Split the line
nmap <Leader>n \i<CR>

" Pull the following line to the cursor position
nmap <silent> <Leader>J :call <SID>Join()<CR>
fun! <SID>Join()
	let l:c = col('.')
	let l:l = line('.')
	s/\%#\(.*\)\n\(.*\)/\2\1/e
	call cursor(l:l,l:c)
endfun

" Select everything
noremap <Leader>gg ggVG

" Reformat everything
noremap <Leader>gq gggqG

" Reindent everything
noremap <Leader>= gg=G

" Map space and backspace to forward/backward screen
map <space> <c-f>
map <backspace> <c-b>

" invoke bufexplorer
imap <F3> <ESC>:BufExplorer<CR>
nmap <F3> :BufExplorer<CR>

" invoke Gundo
nnoremap <F5> :GundoToggle<CR>

" invoke Command-T for buffers
nmap <leader>bb :CommandTBuffer<CR>

noremap <leader>l :TagbarToggle<CR>

"--------------------------------------
" plugin / script / app settings
"--------------------------------------

" Perl specific options
let perl_include_pod=1
let perl_fold=1
let perl_fold_blocks=1

" Show tabs and trailing whitespace visually
set list listchars=tab:\|\ ,trail:.,extends:>,precedes:<

" Settings for :TOhtml
let html_number_lines=1
let html_use_css=1
let use_xhtml=1

"-------------------------------------
" syntax / filetypes
"-------------------------------------

" Only do this part when compiled with support for autocommands.
if has("autocmd")

	" Enable file type detection.
	" Use the default filetype settings, so that mail gets 'tw' set to 72,
	" 'cindent' is on in C files, etc.
	" Also load indent files, to automatically do language-dependent indenting.
	filetype plugin indent on

	" Put these in an autocmd group, so that we can delete them easily.
	augroup vimrcEx
		au!

		" For all text files set 'textwidth' to 78 characters.
		autocmd FileType text setlocal textwidth=78

		" When editing a file, always jump to the last known cursor position.
		" Don't do it when the position is invalid or when inside an event handler
		" (happens when dropping a file on gvim).
		autocmd BufReadPost *
					\ if line("'\"") > 0 && line("'\"") <= line("$") |
					\   exe "normal g`\"" |
					\ endif

	augroup END

else

	set autoindent		" always set autoindenting on

endif " has("autocmd")
