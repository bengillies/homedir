"set compatibility mode with vi
set nocompatible

"vundle config
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

"Vundled GitHub packages
Plugin 'VundleVim/Vundle.vim'
Plugin 'gmarik/vundle.vim'
Plugin 'Shougo/vimproc.vim'
Plugin 'Shougo/unite.vim'
Plugin 'Shougo/denite.nvim'
Plugin 'Shougo/neoyank.vim'
Plugin 'vim-scripts/matchit.zip'
Plugin 'tpope/vim-surround'
Plugin 'bengillies/vim-slime'
Plugin 'bling/vim-airline'
Plugin 'ap/vim-css-color'
Plugin 'kchmck/vim-coffee-script'
Plugin 'juvenn/mustache.vim'
Plugin 'tpope/vim-haml'
Plugin 'tpope/vim-fugitive'
Plugin 'groenewege/vim-less'
Plugin 'nono/vim-handlebars'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'conormcd/matchindent.vim'
Plugin 'ternjs/tern_for_vim'
Plugin 'majutsushi/tagbar'
Plugin 'skywind3000/asyncrun.vim'
Plugin 'vim-scripts/AnsiEsc.vim'

"Bundles from https://github.com/vim-scripts
Bundle 'VimClojure'
Bundle 'pydoc.vim'

call vundle#end()

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

"use indents of 4 spaces apart from ruby, handlebars and coffeescript, js where we want 2
set softtabstop=4
set shiftwidth=4
set tabstop=4
autocmd FileType ruby setlocal softtabstop=2
autocmd FileType ruby setlocal shiftwidth=2
autocmd FileType ruby setlocal tabstop=2
autocmd FileType coffee setlocal softtabstop=2
autocmd FileType coffee setlocal shiftwidth=2
autocmd FileType coffee setlocal tabstop=2
autocmd FileType javascript setlocal softtabstop=2
autocmd FileType javascript setlocal shiftwidth=2
autocmd FileType javascript setlocal tabstop=2
autocmd FileType mustache setlocal softtabstop=2
autocmd FileType mustache setlocal shiftwidth=2
autocmd FileType mustache setlocal tabstop=2

"tabs instead of spaces
"apart from python, Ruby, Handlebars and CoffeeScript where we want spaces.
set noexpandtab
autocmd FileType python setlocal expandtab
autocmd FileType ruby setlocal expandtab
autocmd FileType coffee setlocal expandtab
autocmd FileType javascript setlocal expandtab
autocmd FileType mustache setlocal expandtab

"set compilers to check syntax
autocmd FileType python set makeprg=pylint\ %
autocmd FileType javascript set makeprg=jslint-wrapper\ --jshint\ %
autocmd FileType css set makeprg=csslint\ %
autocmd FileType coffee set makeprg=coffeelint\ %

"beautify json files (use jq which gives 2 space indentation)
autocmd BufNewFile,BufRead *.json set filetype=json
autocmd BufNewFile,BufRead *.json set syntax=javascript
autocmd FileType json vmap = :!jq .<CR>

"set up easy testing and linting
nmap <Leader>l :make<CR><CR>:copen<CR>
nmap <Leader>t :!if [ -e Makefile ]; then make test; elif [ -e Rakefile ]; then rake test; elif [ -e Gruntfile.js ]; then grunt test; elif [ -e Gulpfile.js ]; then gulp test; elif [ -e package.json ]; then npm run test --silent; fi<CR>
nmap <Leader>m :!make<CR>

"easy upload
nmap <Leader>u :!make upload<CR><CR>

"Show trailing whitepace and spaces before a tab:
2match ErrorMsg '\s\+$\| \+\ze\t'

"Do >80 column line indication
if exists("+colorcolumn")
	set colorcolumn=80
else
	match ErrorMsg '\%>80v.\+'
endif

"set ctags up correctly
let Tlist_Ctags_Cmd="/usr/local/bin/ctags"

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
"set ignorecase

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

"fix spelling mistakes
autocmd filetype javascript iabbrev retrun return
autocmd filetype javascript iabbrev lenght length

"set *.es6 = JavaScript
autocmd BufRead,BufNewFile *.es6 setlocal filetype=javascript

"set *.md = Markdown
autocmd BufRead,BufNewFile *.md setlocal filetype=markdown

"Map tagbar to <F7>
noremap <F7> :TagbarToggle<CR>

"set JS jump to definition to use ternjs
autocmd filetype javascript nmap <silent> gd :TernDef<CR>
autocmd filetype javascript nmap <silent> gD :TernDef<CR>

"write files without opening vim up as sudo ...
cmap w!! w !sudo tee % > /dev/null

"clear highlighted searches
nmap <silent> <Leader>/ :let @/=""<CR>

"easier navigation around windows (handled by vim-tmux-navigator)
" noremap <C-h> <C-w>h
" noremap <C-j> <C-w>j
" noremap <C-k> <C-w>k
" noremap <C-l> <C-w>l

"vimclojure settings
let vimclojure#HighlightBuiltins = 1
let vimclojure#ParenRainbow = 1
let vimclojure#DynamicHighlighting = 1
let vimclojure#FuzzyIndent = 1

"use matchit plugin
runtime plugin/matchit.vim

"easy splitting
nmap \ :vsp<CR>
nmap - :sp<CR>
nmap <C-t> :tabnew<CR>
nmap <C-n> :tabnext<CR>
nmap <C-p> :tabprevious<CR>

"denite.nvim settings

"ignore directories
call denite#custom#filter('matcher_ignore_globs', 'ignore_globs', ['.git/', 'node_modules/', 'build/', 'dist/', 'tmp/', 'log/', 'coverage/', '.node-mailer', '.sass-cache/', 'bower_components/', '.happypack/'])
"increase cache
call denite#custom#source('<', 'min_cache_files', 200000)

"keymappings
call denite#custom#map('insert', '<C-j>', '<denite:move_to_next_line>', 'noremap')
call denite#custom#map('insert', '<C-k>', '<denite:move_to_previous_line>', 'noremap')
call denite#custom#map('insert', '<C-d>', '<denite:scroll_window_downwards>', 'noremap')
call denite#custom#map('insert', '<C-u>', '<denite:scroll_window_upwards>', 'noremap')
call denite#custom#map('insert', '<C-t>', '<denite:do_action:tabopen>', 'noremap')
call denite#custom#map('insert', '<C-l>', '<denite:redraw>', 'noremap')

"use ag to search with
call denite#custom#var('file_rec', 'command', ['ag', '--follow', '--nocolor', '--nogroup', '--hidden', '-g', ''])
call denite#custom#source('file_rec', 'matchers', ['matcher_fuzzy', 'matcher_ignore_globs'])

"use ag to grep
call denite#custom#var('grep', 'command', ['ag'])
call denite#custom#var('grep', 'default_opts', ['-i', '--vimgrep'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', [])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])

"command shortcuts

"legacy unite file drawer
noremap <F2> :Unite -no-split file<CR>
noremap <F3> :UniteWithBufferDir -no-split file<CR>

"file search from base dir
nnoremap <silent> <space>f :Denite file_rec<CR>
nnoremap <silent> <Leader>f :Denite file_rec<CR>
"file search from current dir
nnoremap <silent> <space>F :DeniteBufferDir file_rec<CR>
nnoremap <silent> <Leader>F :DeniteBufferDir file_rec<CR>
"grep across files
nnoremap <silent> <space>g :Denite grep<CR>
nnoremap <silent> <Leader>g :Denite grep<CR>
"grep for word inside file
nnoremap <silent> <Leader><Leader> :DeniteCursorWord line<CR>
"grep for search term inside file
nnoremap <silent> <Leader>* :Denite line -input=<C-r>/<CR>
"yank search (with neoyank)
nnoremap <silent> <Leader>y :Denite neoyank<CR>
nnoremap <silent> <space>y :Denite neoyank<CR>
"buffer search
nnoremap <silent> <space>b :Denite buffer<CR>
nnoremap <silent> <Leader>b :Denite buffer<CR>

"end denite.nvim settings

"add a status line
set laststatus=2

"set 8 colors
"set t_Co=8

"set up relative line numbering
function! RelNumToggle()
  if(&relativenumber == 1)
    set norelativenumber
  else
    set relativenumber
  endif
endfunc

nnoremap <Leader>n :call RelNumToggle()<cr>

"set spellcheck
nmap <Leader>s :setlocal spell! spelllang=en_gb<CR>

"set absolute line numbering automatically on certain events
:au FocusLost * :set number
:au FocusGained * :set relativenumber
autocmd InsertEnter * :set number
autocmd InsertLeave * :set relativenumber

"set slime to use tmux
let g:slime_target = "tmux"

"remove slime default key mappings
let g:slime_no_mappings = 1

"tell Airline to use fance font rendering
let g:airline_powerline_fonts = 1

"make sure term is set to screen-256color
set term=screen-256color

"set up keybindings for slime (C-c is an awful default)
"<C-e> in visual mode to send region
"<C-e> + motion to send motion
"<C-e><C-e> to send line
"<leader>v to switch to a different target pane
xmap <C-e> <Plug>SlimeRegionSend
nmap <C-e> <Plug>SlimeMotionSend
nmap <C-e><C-e> <Plug>SlimeLineSend
nmap <leader>v <Plug>SlimeConfig

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

"remove indenting for JS/Ruby
autocmd FileType ruby set indentexpr=cindent
autocmd FileType javascript set indentexpr=cindent

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
