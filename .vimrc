"set compatibility mode with vi
set nocompatible

"vundle config
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

"Vundled GitHub packages
Plugin 'VundleVim/Vundle.vim'
Plugin 'gmarik/vundle.vim'
"Plugin 'Shougo/vimproc.vim'
Plugin 'vim-denops/denops.vim'
Plugin 'vim-denops/denops-shared-server.vim'
Plugin 'Shougo/ddu.vim'
Plugin 'Shougo/neoyank.vim'
Plugin 'tpope/vim-surround'
Plugin 'bengillies/vim-slime'
Plugin 'bling/vim-airline'
Plugin 'ap/vim-css-color'
Plugin 'nono/vim-handlebars'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'conormcd/matchindent.vim'
Plugin 'skywind3000/asyncrun.vim'
Plugin 'vim-scripts/AnsiEsc.vim'
"Plugin 'roxma/nvim-yarp'
"Plugin 'roxma/vim-hug-neovim-rpc'

"ddu plugins
Plugin 'Shougo/ddu-ui-ff'
Plugin 'Shougo/ddu-kind-file'
Plugin 'Shougo/ddu-kind-word'
Plugin 'Shougo/ddu-source-line'
Plugin 'Shougo/ddu-source-action'
Plugin 'Shougo/ddu-source-register'
Plugin 'Shougo/ddu-filter-matcher_substring'
Plugin 'Shougo/ddu-filter-converter_display_word'
Plugin 'matsui54/ddu-filter-fzy'
Plugin 'matsui54/ddu-source-file_external'
Plugin 'shun/ddu-source-rg'
Plugin 'shun/ddu-source-buffer'

"autocomplete plugins
Plugin 'prabirshrestha/vim-lsp'
Plugin 'mattn/vim-lsp-settings'
Plugin 'Shougo/ddc.vim'
Plugin 'Shougo/ddc-ui-native'
Plugin 'Shougo/ddc-ui-none'
Plugin 'shun/ddc-source-vim-lsp'
Plugin 'matsui54/ddc-buffer'
Plugin 'Shougo/ddc-matcher_head'
Plugin 'Shougo/ddc-sorter_rank'
"Plugin 'bengillies/denite-vim-lsp'
Plugin 'uga-rosa/ddu-source-lsp'
Plugin 'github/copilot.vim'

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
autocmd FileType javascript,typescript,typescriptreact setlocal softtabstop=2
autocmd FileType javascript,typescript,typescriptreact setlocal shiftwidth=2
autocmd FileType javascript,typescript,typescriptreact setlocal tabstop=2
autocmd FileType mustache setlocal softtabstop=2
autocmd FileType mustache setlocal shiftwidth=2
autocmd FileType mustache setlocal tabstop=2

"tabs instead of spaces
"apart from python, Ruby, Handlebars and CoffeeScript where we want spaces.
set noexpandtab
autocmd FileType python setlocal expandtab
autocmd FileType ruby setlocal expandtab
autocmd FileType coffee setlocal expandtab
autocmd FileType javascript,typescript,typescriptreact setlocal expandtab
autocmd FileType mustache setlocal expandtab

"set compilers to check syntax
autocmd FileType python set makeprg=pylint\ %
autocmd FileType javascript set makeprg=jslint-wrapper\ --jshint\ %
autocmd FileType css set makeprg=csslint\ %
autocmd FileType coffee set makeprg=coffeelint\ %

"beautify json files (use jq which gives 2 space indentation)
autocmd BufNewFile,BufRead *.json set filetype=json
autocmd BufNewFile,BufRead *.json set syntax=javascript
autocmd BufNewFile,BufRead *.json5 set filetype=javascript
autocmd FileType json vmap = :!jq .<CR>

" force javascriptreact files to be javascript (at least, until I fix up the
" default javascriptreact mode to be more like my custom javascript one
autocmd BufNewFile,BufRead *.jsx set filetype=javascript

"set up easy testing and linting
nmap <Leader>l :make<CR><CR>:copen<CR>
nmap <Leader>t :!if [ -e Makefile ]; then make test; elif [ -e Rakefile ]; then rake test; elif [ -e Gruntfile.js ]; then grunt test; elif [ -e Gulpfile.js ]; then gulp test; elif [ -e package.json ]; then npm run test --silent; fi<CR>
nmap <Leader>T :!if [ -e Makefile ]; then make test; elif [ -e Rakefile ]; then rake test; elif [ -e Gruntfile.js ]; then grunt test; elif [ -e Gulpfile.js ]; then gulp test; elif [ -e package.json ]; then npm run test --silent -- %; fi<CR>
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
nmap <silent><Enter> o<ESC>
nmap <silent><S-Enter> O<ESC>

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
autocmd filetype javascript,typescript,typescriptreact iabbrev retrun return
autocmd filetype javascript,typescript,typescriptreact iabbrev lenght length

"set *.es6 = JavaScript
autocmd BufRead,BufNewFile *.es6 setlocal filetype=javascript

"set *.md = Markdown
autocmd BufRead,BufNewFile *.md setlocal filetype=markdown

"start of vim-lsp settings

"open quickfix with all references to variable in
"autocmd filetype javascript,typescript,typescriptreact nmap <silent> gd <plug>(lsp-references)
nmap <silent> gd <plug>(lsp-references)
"jump to definition in same file, or open a new buffer with the definition in
"autocmd filetype javascript,typescript,typescriptreact nmap <silent> gD :keepalt LspDefinition<CR>
nmap <silent> gD :keepalt LspDefinition<CR>
"display type information under cursor (NUL maps to C-Space)
"autocmd filetype javascript,typescript,typescriptreact nmap <silent> <C-Space> :keepalt LspHover<CR>
nmap <silent> <C-Space> :keepalt LspHover<CR>
"autocmd filetype javascript,typescript,typescriptreact nmap <silent> <NUL> :keepalt LspHover<CR>
nmap <silent> <NUL> :keepalt LspHover<CR>
"display actions to perform on file (e.g. update imports)
"autocmd filetype javascript,typescript,typescriptreact nmap <silent> <Leader>a :LspCodeAction source.addMissingImports.ts<CR>
nmap <silent> <Leader>a :LspCodeAction source.addMissingImports.ts<CR>
nmap <silent> <C-s> :LspCodeAction --ui=float<CR>
nmap <silent> <Space>e :LspNextError<CR>

"turn off 2 column hint next to line number column
set signcolumn=no

"show error information
let g:lsp_diagnostics_float_cursor = 0

"turn off displaying diagnostic info all the time as a separate row
let g:lsp_diagnostics_virtual_text_enabled = 1
let g:lsp_diagnostics_virtual_text_insert_mode_enabled = 0
let g:lsp_diagnostics_virtual_text_align = 'right'
let g:lsp_diagnostics_highlights_enabled = 1

"end of vim-lsp end settings

"jump to quickfix line with enter
autocmd filetype qf nmap <silent><Enter> :.cc<CR>

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

"easy splitting
nmap \ :vsp<CR>
nmap - :sp<CR>
nmap <C-t> :tabnew<CR>
nmap <C-n> :tabnext<CR>
nmap <C-p> :tabprevious<CR>


"start of ddu configuration
call ddu#custom#patch_global(#{
	\   ui: 'ff',
	\   uiParams: #{
	\     ff: #{
	\       autoResize: v:true,
	\       prompt: '> ',
	\     },
	\   },
	\   kindOptions: #{
	\     file: #{
	\       defaultAction: 'open',
	\     },
	\     word: #{
	\       defaultAction: 'yank',
	\     },
	\     action: #{
	\       defaultAction: 'do',
	\     },
	\   },
	\   sourceOptions: {
	\     '_': {
	\       'matchers': ['converter_display_word', 'matcher_fzy'],
	\     },
	\   }
	\ })


autocmd FileType ddu-ff call s:ddu_ff_my_settings()
function s:ddu_ff_my_settings() abort

	nnoremap <buffer><expr> <CR> get(ddu#ui#get_item(), 'isTree', v:false)
	\	? "<Cmd>call ddu#ui#sync_action('itemAction', { 'name': 'narrow' })<CR>"
	\	: "<Cmd>call ddu#ui#sync_action('itemAction')<CR>"

	nnoremap <buffer> <Tab> <Cmd>call ddu#ui#do_action('chooseAction')<CR>
	nnoremap <buffer> y <Cmd>call ddu#ui#multi_actions([['itemAction', { 'name': 'yank' }], ['quit']])<CR>
	nnoremap <buffer> i <Cmd>call ddu#ui#do_action('openFilterWindow')<CR>
	nnoremap <buffer> q <Cmd>call ddu#ui#do_action('quit')<CR>
	nnoremap <buffer> <Esc> <Cmd>call ddu#ui#do_action('quit')<CR>
endfunction

autocmd FileType ddu-ff-filter call s:ddu_ff_filter_my_settings()
function s:ddu_ff_filter_my_settings() abort
	inoremap <buffer> <CR> <Esc><Cmd>call ddu#ui#do_action('closeFilterWindow')<CR>
	nnoremap <buffer> <CR> <Cmd>call ddu#ui#do_action('closeFilterWindow')<CR>

	inoremap <buffer> <Esc> <Esc><Cmd>call ddu#ui#do_action('closeFilterWindow')<CR>
	nnoremap <buffer> <Esc> <Cmd>call ddu#ui#do_action('closeFilterWindow')<CR>

	nnoremap <buffer> q <Cmd>call ddu#ui#do_action('closeFilterWindow')<CR>
endfunction

call ddu#custom#alias('source', 'file_rec', 'file_external')
call ddu#custom#patch_global('sourceParams', {
	\   'file_rec': {
	\     'cmd': ['/opt/homebrew/bin/ag', '--follow', '--nocolor', '--nogroup', '-g', '.'],
	\     'updateItems': 200000
	\   },
	\ })

call ddu#custom#alias('source', 'file_browser', 'file_external')
call ddu#custom#patch_global('sourceParams', {
	\   'file_browser': {
	\     'cmd': ['/opt/homebrew/bin/gls', '--group-directories-first', '-aF', '-I', '.sw*', '-I', '.*.sw*']
	\   },
	\ })

call ddu#custom#alias('source', 'grep', 'rg')
call ddu#custom#patch_global('sourceParams', {
	\   'grep': {
	\     'args': ['--column', '--no-heading', '--json']
	\   },
	\ })

call ddu#custom#patch_global('sourceOptions', {
	\   'line': {
	\     'matchers': ['matcher_substring'],
	\   },
	\ })


"fuzzy find files
nnoremap <silent> <Leader>f :call ddu#start({'sources': [{'name': 'file_rec'}], 'uiParams': {'ff': {'startFilter': v:true}}})<CR>

"file listing from current buffer dir
nnoremap <silent> <Leader>F :call ddu#start({'sources': [{'name': 'file_browser', 'options': {'path': expand('%:h')}}], 'uiParams': {'ff': {'autoResize': v:false}}})<CR>

"grep across files
nnoremap <silent> <Space>g :call ddu#start(#{ sources: [{ name: 'grep', params: { input: input('Pattern:')}}]})<CR>

"buffer search
nnoremap <silent> <Leader>b :call ddu#start({'sources': [{'name': 'buffer'}]})<CR>

"list registers for yank history
nnoremap <silent> <Leader>y :call ddu#start({'sources': [{'name': 'register'}]})<CR>

"grep for word or highlight inside file (word under cursor in normal mode, selection in visual mode)
nnoremap <silent> <Leader><Leader> :call ddu#start({'sources': [{'name': 'line'}], 'input': expand('<cword>')})<CR>
vnoremap <silent> <Leader><Leader> "uy:call ddu#start({'sources': [{'name': 'line'}], 'input': getreg("u")})<CR>

""outline current file
"nnoremap <silent> <F7> :Denite lsp_document_symbol<CR>
""new file in current file directory
"nnoremap <silent> <Leader>o :DeniteBufferDir -start-filter file:new<CR>

call ddu#load('ui', ['ff'])
call ddu#load('source', ['file_external', 'file_browser', 'grep', 'file_rec', 'line', 'register', 'buffer'])
call ddu#load('kind', ['file','word', 'action'])
call ddu#load('filter', ['converter_display_word', 'matcher_fzy'])
"end of ddu configuration

"start of denops settings
let g:denops_server_addr = '127.0.0.1:32123'
"end denops settings

"start of ddc (autocomplete settings)

call ddc#custom#patch_global('sources', ['vim-lsp', 'buffer'])
call ddc#custom#patch_global('sourceOptions', {
	\ 'vim-lsp': {
	\   'matchers': ['matcher_head'],
	\   'minAutoCompleteLength': 0,
	\   'sorters': ['sorter_rank'],
	\   'mark': 'lsp',
	\ },
	\ 'buffer': {
	\   'matchers': ['matcher_head'],
	\   'minAutoCompleteLength': 0,
	\   'sorters': ['sorter_rank'],
	\   'mark': 'B',
	\ },
	\ })

call ddc#custom#patch_global('sourceParams', {
	\ 'buffer': {
	\   'requireSameFiletype': v:false,
	\   'limitBytes': 5000000,
	\   'fromAltBuf': v:true,
	\   'forceCollect': v:true,
	\ }
	\ })

"turn off autocomplete on type
call ddc#custom#patch_global('ui', 'none')

"set regular autocomplete (C-n) to use ddc native popups
:inoremap <silent><expr><C-n> ddc#map#complete('native')

call ddc#enable()
"end of ddc (autocomplete settings)

"start airline settings

"add a status line
set laststatus=2

"tell airline to use fancy font rendering
let g:airline_powerline_fonts = 1

"customise the statusline
"a=mode
"b=branch
"c=filename
"x=tag + filetype
"y=file encoding
"z=percentage + line number
let g:airline#extensions#default#layout = [
	\ [ 'a', 'c' ],
	\ [ 'x', 'error', 'warning' ]
\ ]

"end airline settings

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

"autoformat JS files
autocmd filetype javascript,typescript,typescriptreact nmap == :!npx prettier -w %<CR><CR>:e<CR>

"set absolute line numbering automatically on certain events
:au FocusLost * :set number
:au FocusGained * :set relativenumber
autocmd InsertEnter * :set number
autocmd InsertLeave * :set relativenumber

"set slime to use tmux
let g:slime_target = "tmux"

"remove slime default key mappings
let g:slime_no_mappings = 1

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
autocmd FileType javascript,typescript,typescriptreact setlocal foldmethod=marker
autocmd FileType javascript,typescript,typescriptreact setlocal foldmarker={,}
autocmd FileType javascript,typescript,typescriptreact setlocal foldtext=MarkerFoldText()

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
autocmd FileType javascript,typescript,typescriptreact set indentexpr=cindent

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
