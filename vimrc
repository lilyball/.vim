" My vimrc file

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Fix colors
set t_Co=16

" set encoding
set encoding=utf8
set fileencoding=utf8

" /bin/sh is bash
let is_bash = 1

" let vim know that .sit, .sitx, and .hqx are compressed files
let g:ft_ignore_pat = '\.\(Z\|gz\|bz2\|zip\|tgz\|sit\|sitx\|hqx\)$'

" start up Pathogen
call pathogen#infect()

if has("vms")
	set nobackup		" do not keep a backup file, use versions instead
else
	set nobackup		" keep a backup file
	set writebackup
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set ignorecase
set smartcase
set nohlsearch
set confirm
set fileformats=unix,mac,dos

" Keep a large viminfo file
set viminfo='1000,f1,:1000,/1000,r/tmp,r/Volumes

" set tabstop
set tabstop=4
set shiftwidth=4

" Set delimitMate preferences
let g:delimitMate_expand_cr = 1

" Allow edit buffers to be hidden
set hidden

" Highlight matching parens
set showmatch

" Show full tags when doing search completion
set showfulltag

" Do nice indent things
set autoindent
set smartindent
inoremap # X<BS>#

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" redraw lazily
" set lazyredraw

" Keep the scrolling context visible
set scrolloff=3
set sidescrolloff=2

" Wrap on these
set whichwrap+=<,>,[,]

" Turn on cool completion
set wildmenu

" Try to load a nice colorscheme
fun! LoadColourScheme(schemes)
	let l:schemes = a:schemes . ":"
	while l:schemes != ""
		let l:scheme = strpart(l:schemes, 0, stridx(l:schemes, ":"))
		let l:schemes = strpart(l:schemes, stridx(l:schemes, ":") + 1)
		try
			exec "colorscheme" l:scheme
			break
		catch
		endtry
	endwhile
endfun

if has('gui_running')
	set background=dark
	call LoadColourScheme("solarized:darkblue:elflord")
else
	if &t_Co == 8
		call LoadColourScheme("darkblue:elflord")
	else
		call LoadColourScheme("darkblue:elflord")
	endif
endif

" Enable folds
set foldenable
set foldmethod=indent
set foldlevel=99
set foldcolumn=1

" Syntax when printing (whenever that is)
set popt+=syntax:y

" Enable modelines
set modeline
set modelines=5

" Nice statusbar
set laststatus=2
fun! <SID>SetStatusLine()
	let l:s1="%-3.3n\\ %f\\ %h%m%r%w"
	let l:s2="[%{strlen(&filetype)?&filetype:'none'},%{&encoding},%{&fileformat}]"
	let l:s3="%=\\ 0x%-8B\\ \\ %-14.(%l,%c%V%)\\ %<%P"
	execute "set statusline=" . l:s1 . l:s2 . l:s3
endfun
call <SID>SetStatusLine()

" If possible (i.e. in vim7) try to use a narrow number column
if v:version >= 700
	try
		setlocal numberwidth=3
	catch
	endtry
endif

"-------------------------
" autocmds
"-------------------------

" If we're in a wide window, enable line numbers
fun! <SID>WindowWidth()
	if bufname('%') != '-MiniBufExplorer-' && &filetype != 'help'
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
	autocmd BufEnter * :call <SID>WindowWidth()

	" Always do a full syntax refresh
	autocmd BufEnter * syntax sync fromstart

	" For help files, move them to the top window and make <Return>
	" behave like <C-]> (jump to tag)
	autocmd FileType help :call <SID>WindowToTop()
	autocmd FileType help nmap <buffer> <Return> <C-]>

	" For the quickfix window, move it to the bottom
	autocmd FileType qf :3 wincmd _ | :call <SID>WindowToBottom()

	" For svn-commit, don't create backups
	autocmd BufRead svn-commit.tmp :setlocal nobackup
	" For svn-commit, always start on line 1
	autocmd BufWinEnter svn-commit.tmp :1

	" For .git/COMMIT_EDITMSG, don't create backups
	autocmd BufRead .git/COMMIT_EDITMSG :setlocal nobackup
	" for .git/COMMIT_EDITMSG, always start on line 1
	autocmd BufWinEnter .git/COMMIT_EDITMSG :1

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

" Commonly used commands
nmap <F5> <C-w>c
nnoremap <F7> :if &filetype == "vim" \| so % \| else \| make \| endif<CR>
noremap <F10> :w !ruby -w > /tmp/vim_r_buff 2>&1<CR>:sv /tmp/vim_r_buff<CR>

" Create HTML for current syntax
nmap	<C-h>	:runtime! syntax/2html.vim<CR>

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

" invoke NERDtree
imap <F4> <ESC>:NERDTreeToggle<CR>
nmap <F4> :NERDTreeToggle<CR>

" invoke bufexplorer
imap <F3> <ESC>:BufExplorer<CR>
nmap <F3> :BufExplorer<CR>

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

" cscope settings
if has('cscope')
	set csto=0
	set cscopetag
	set nocsverb
	if filereadable("cscope.out")
		cs add cscope.out
	endif
	set csverb

	let x = "sgctefd"
	while x != ""
		let y = strpart(x, 0, 1) | let x = strpart(x, 1)
		exec "nmap <C-j>" . y . " :cscope find " . y .
					\ "<C-R>=expand(\"\<cword\>\")<CR><CR>"
		exec "nmap <C-j><C-j>" . y . " :scscope find " . y .
					\ "<C-R>=expand(\"\<cword\>\")<CR><CR>"
	endwhile
	nmap <C-j>i			:cscope find i ^<C-R>=expand("<cword>")<CR><CR>
	nmap <C-j><C-j>i	:scscope find i ^<C-R>=expand("<cword>")<CR><CR>
endif

"-------------------------------------
" syntax / filetypes
"-------------------------------------

" Switch syntax highlighting on, when the terminal has colors
if &t_Co > 2 || has("gui_running")
	syntax on
endif

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
