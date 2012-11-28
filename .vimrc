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

"make Y behave like other capitals
map Y y$

"reselect highlighted blocks after indent/outdent
vnoremap > >gv
vnoremap < <gv

"automatically indent new lines
set autoindent
set smartindent

"use indents of 4 spaces apart from ruby and coffeescript, where we want 2
set softtabstop=4
set shiftwidth=4
set tabstop=4
autocmd FileType ruby setlocal softtabstop=2
autocmd FileType ruby setlocal shiftwidth=2
autocmd FileType ruby setlocal tabstop=2
autocmd FileType coffee setlocal softtabstop=2
autocmd FileType coffee setlocal shiftwidth=2
autocmd FileType coffee setlocal tabstop=2

"tabs instead of spaces
"apart from python, Ruby and CoffeeScript where we want spaces.
set noexpandtab
autocmd FileType python setlocal expandtab
autocmd FileType ruby setlocal expandtab
autocmd FileType coffee setlocal expandtab

"set compilers to check syntax
autocmd FileType python compiler pylint
autocmd FileType javascript set makeprg=jslint-wrapper\ --jshint\ %
autocmd FileType css set makeprg=csslint\ %
autocmd FileType coffee set makeprg=coffeelint\ %

"set up easy testing and linting
nmap <Leader>l :make<CR><CR>:copen<CR>
nmap <Leader>t :!if [ -e Makefile ]; then make test; else rake test; fi<CR>
nmap <Leader>m :!make<CR>

"easy upload
nmap <Leader>u :!make upload<CR><CR>

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
set listchars=tab:\▸\ ,trail:·

"highlight current cursor line and column
set cursorline
set cursorcolumn

"set color stuff
syntax on
set background=dark
colorscheme elrodeo

"<Enter> and <Shift><Enter> insert lines without going into insert mode
map <Enter> o<ESC>
map <S-Enter> O<ESC>

"turn off the bell
set vb t_vb= 

"let filetypes give specific info to plugins
filetype plugin on

"set TiddlyWiki mode
autocmd BufNewFile,BufRead *.tid set filetype=TiddlyWiki
autocmd filetype TiddlyWiki set wrap
autocmd filetype TiddlyWiki set linebreak
autocmd filetype TiddlyWiki set nolist "list disables linebreak
autocmd filetype TiddlyWiki set textwidth=0
autocmd filetype TiddlyWiki set wrapmargin=0

"set *.md = Markdown
autocmd BufRead,BufNewFile *.md setlocal filetype=markdown

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
let vimclojure#DynamicHighlighting = 1

"use matchit plugin
runtime plugin/matchit.vim

"setup Command-T to use <Leader>f (cos 't' means test)
nnoremap <silent> <Leader>f :CommandT<CR>

"setup Command-T to open files in split screen with C-i (like in NERDTree)
let g:CommandTAcceptSelectionSplitMap=['<C-o>']

"add a status line
set laststatus=2

"set 8 colors
"set t_Co=8

"set up relative line numbering
function! RelNumToggle()
  if(&relativenumber == 1)
    set number
  else
    set relativenumber
  endif
endfunc

nnoremap <Leader>n :call RelNumToggle()<cr>

"set absolute line numbering automatically on certain events
:au FocusLost * :set number
:au FocusGained * :set relativenumber
autocmd InsertEnter * :set number
autocmd InsertLeave * :set relativenumber

"set slime to use tmux
let g:slime_target = "tmux"

"tell Powerline to use fance font rendering
let g:Powerline_symbols = 'fancy'

"make sure term is set to screen-256color
set term=screen-256color

"set up keybindings for slime (C-c is an awful default)
let g:slime_send_key = '<leader>e'
let g:slime_config_key = '<Leader>v'

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

autocmd FileType html setlocal foldmethod=indent


"don't apply the folds automatically
set foldlevelstart=99

"remove some annoying commands
noremap <F1> <nop>
noremap K <nop>

"toggle tab mode between tabs and 2 spaces
nmap <Leader>q :call ToggleTabs()<CR>
function! ToggleTabs()
  if &softtabstop == 2
    set softtabstop=4
    set shiftwidth=4
    set noexpandtab
  else
    set softtabstop=2
    set shiftwidth=2
    set expandtab
  endif
endfunction

"vimclojure indenting
filetype plugin indent on

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
