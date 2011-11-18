"set compatibility mode with vi
set nocompatible

"set less timeout to speed vim up
set notimeout
set ttimeout
set timeoutlen=50

"set <Leader> to ","
let mapleader=","

"mininum of lines to keep above/below the cursor
set scrolloff=2

"turn on line numbers
:set number

"turn on the ruler
:set ruler

"set auto complete of commands to list options and complete longest part of match first
set wildmode=list:longest,full

"enable filetype detection
filetype on

"wrap long lines
set wrap

"automatically indent new lines
set autoindent
set smartindent

"use indents of 4 spaces
set softtabstop=4
set shiftwidth=4
set tabstop=4

"tabs instead of spaces
"apart from python, where we want spaces.
set noexpandtab
autocmd FileType python setlocal expandtab

"set compilers to check syntax
autocmd FileType python compiler pylint
autocmd FileType javascript set makeprg=jslint-wrapper\ %
autocmd FileType css set makeprg=csslint\ %

"set up easy testing and linting
nmap <Leader>l :make<CR><CR>:copen<CR>
nmap <Leader>t :!make test<CR>
nmap <Leader>m :!make

"don't call pylint after _every_ single :w (it's really annoying)
let g:pylint_onwrite = 0

"Show trailing whitepace and spaces before a tab:
match ErrorMsg /\s\+$\| \+\ze\t/

"Do >80 column line indication
if exists("+colorcolumn")
	set colorcolumn=80
else
	match ErrorMsg '\%>80v.\+'
endif

"pastetoggle (sane indentation on pastes) just press F5 when you are
"going to paste several lines of text so they won't be indented.
"When in paste mode, everything is inserted literally.
set pastetoggle=<F5>

"set the encoding
set encoding=utf-8

"ignore these file types when opening
set wildignore=*.pyc,*.o,*.obj,*.swp


"show search results as you type
set incsearch

"highlight all search matches
set hlsearch

"set the backspace key to include new lines, tabs, etc
set backspace=indent,eol,start

"ignore case when searching
set ignorecase

" display whitespace characters
set list
set listchars=tab:⋯\ ,trail:·

"highlight current cursor line and column
set cursorline
set cursorcolumn

"set color stuff
syntax on
set background=dark
colorscheme desert

"<Enter> and <Shift><Enter> insert lines without going into insert mode
map <Enter> o<ESC>
map <S-Enter> O<ESC>

"turn off the bell
set vb t_vb= 

"let filetypes give specific info to plugins
filetype plugin on
autocmd filetype clojure filetype plugin indent on

"set TiddlyWiki mode
autocmd BufNewFile,BufRead *.tid set filetype=TiddlyWiki
autocmd filetype TiddlyWiki set wrap
autocmd filetype TiddlyWiki set linebreak
autocmd filetype TiddlyWiki set nolist "list disables linebreak
autocmd filetype TiddlyWiki set textwidth=0
autocmd filetype TiddlyWiki set wrapmargin=0

"Map some function keys for NERDTree
noremap <F2> :NERDTreeToggle<CR>
noremap <F3> :NERDTreeFind<CR>
noremap <F4> :NERDTreeClose<CR>

"Map taglist to <F7>
noremap <F7> :TlistToggle<CR>

"write files without opening vim up as sudo ...
cmap w!! w !sudo tee % > /dev/null

"clear highlighted searches
nmap <silent> <Leader>/ :let @/=""<CR>

"copy/paste contents of file to/from the clipboard
map <silent> <Leader>y :w !pbcopy<CR><CR>
map <silent> <Leader>p "*p

"easier navigation around windows
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

"vimclojure settings
let vimclojure#HighlightBuiltins = 1
let vimclojure#ParenRainbow = 1

"use matchit plugin
runtime plugin/matchit.vim

"add a status line
set laststatus=2

"set 8 colors
set t_Co=8

"do fancy status line color thing
"(http://www.reddit.com/r/vim/comments/gexi6/a_smarter_statusline_code_in_comments/)
hi StatColor guibg=#95e454 guifg=black ctermbg=lightgreen ctermfg=black
hi Modified guibg=orange guifg=black ctermbg=lightred ctermfg=black

function! MyStatusLine(mode)
    let statusline=""
    if a:mode == 'Enter'
        let statusline.="%#StatColor#"
    endif
    let statusline.="\(%n\)\ %f\ "
    if a:mode == 'Enter'
        let statusline.="%*"
    endif
    let statusline.="%#Modified#%m"
    if a:mode == 'Leave'
        let statusline.="%*%r"
    elseif a:mode == 'Enter'
        let statusline.="%r%*"
    endif
    let statusline .= "\ (%l/%L,\ %c)\ %P%=%h%w\ %y\ [%{&encoding}:%{&fileformat}]\ \ "
    return statusline
endfunction

au WinEnter * setlocal statusline=%!MyStatusLine('Enter')
au WinLeave * setlocal statusline=%!MyStatusLine('Leave')
set statusline=%!MyStatusLine('Enter')

function! InsertStatuslineColor(mode)
  if a:mode == 'i'
    hi StatColor guibg=orange ctermbg=lightred
  elseif a:mode == 'r'
    hi StatColor guibg=#e454ba ctermbg=magenta
  elseif a:mode == 'v'
    hi StatColor guibg=#e454ba ctermbg=magenta
  else
    hi StatColor guibg=red ctermbg=red
  endif
endfunction

au InsertEnter * call InsertStatuslineColor(v:insertmode)
au InsertLeave * hi StatColor guibg=#95e454 guifg=black ctermbg=lightgreen ctermfg=black

"set the colorcolumn to dark
hi ColorColumn ctermbg=0

"set up code folding
autocmd FileType javascript setlocal foldmethod=marker
autocmd FileType javascript setlocal foldmarker={,}
autocmd FileType javascript setlocal foldtext=MarkerFoldText()

autocmd FileType css setlocal foldmethod=marker
autocmd FileType css setlocal foldmarker={,}
autocmd FileType css setlocal foldtext=MarkerFoldText()

autocmd FileType python setlocal foldmethod=indent

autocmd FileType html setlocal foldmethod=manual


"don't apply the folds automatically
set foldlevelstart=99

"remove some annoying commands
noremap <F1> <nop>
noremap K <nop>

"set fold highlight colours
highlight Folded ctermfg=Grey ctermbg=0

"define a function for marker'd fold text
function! MarkerFoldText()
  let line = getline(v:foldstart)
  if match( line, '^[ \t]*\(\/\*\|\/\/\)[*/\\]*[ \t]*$' ) == 0
    let initial = substitute( line, '^\([ \t]\)*\(\/\*\|\/\/\)\(.*\)', '\1\2', '' )
    let linenum = v:foldstart + 1
    while linenum < v:foldend
      let line = getline( linenum )
      let comment_content = substitute( line, '^\([ \t\/\*]*\)\(.*\)$', '\2', 'g' )
      if comment_content != ''
        break
      endif
      let linenum = linenum + 1
    endwhile
    let sub = initial . ' ' . comment_content
  else
    let sub = line
    let startbrace = substitute( line, '^.*{[ \t]*$', '{', 'g')
    if startbrace == '{'
      let line = getline(v:foldend)
      let endbrace = substitute( line, '^[ \t]*}\(.*\)$', '}', 'g')
      if endbrace == '}'
        let sub = sub.substitute( line, '^[ \t]*}\(.*\)$', '...}\1', 'g')
      endif
    endif
  endif
  let n = v:foldend - v:foldstart + 1
  let info = " " . n . " lines"
  let sub = sub . "                                                                                                                  "
  let num_w = getwinvar( 0, '&number' ) * getwinvar( 0, '&numberwidth' )
  let fold_w = getwinvar( 0, '&foldcolumn' )
  let sub = strpart( sub, 0, winwidth(0) - strlen( info ) - num_w - fold_w - 1 )
  return sub . info
endfunction
