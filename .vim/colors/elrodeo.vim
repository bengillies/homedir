" Vim color file
" Name: elrodeo
" Maintainer: Christian Müller (@chmllr)
" Version: 1.0
"
" Inspired by the color scheme used by ibdknox.

"set background=dark

hi clear
if exists("syntax_on")
    syntax reset
endif

let g:colors_name="elrodeo"

" the nexz block is copied from the wombat theme:
" Vim >= 7.0 specific colors
if version >= 700
"  hi CursorLine ctermbg=59
  hi CursorColumn ctermbg=0
  hi ColorColumn ctermbg=0
  hi MatchParen ctermfg=230 ctermbg=101 cterm=bold
  hi Pmenu		ctermfg=230 ctermbg=59
  hi PmenuSel	ctermfg=16
endif
" General colors
hi Normal		ctermfg=230
hi Cursor		ctermfg=59
hi NonText		ctermfg=102
hi LineNr		ctermfg=59
hi StatusLine	ctermfg=230
hi StatusLineNC ctermfg=59 ctermbg=15
hi VertSplit	ctermfg=59
hi Folded		ctermbg=59 ctermfg=145
hi Title		ctermfg=230 ctermbg=NONE	cterm=bold
hi Visual		ctermfg=230
hi SpecialKey	ctermfg=102


" Syntax highlighting
hi Comment		ctermfg=66
hi Operator		ctermfg=141
hi Todo			ctermfg=59
hi Constant		ctermfg=white
hi String		ctermfg=153
hi Identifier	ctermfg=72
hi Define		ctermfg=72
hi Function		ctermfg=72
hi Macro        ctermfg=72
hi Number		ctermfg=66
hi Special		ctermfg=72
hi Conditional  ctermfg=72
hi Boolean      ctermfg=114
hi Delimiter    ctermfg=102
hi Character    ctermfg=81
hi Search       ctermfg=black ctermbg=72
hi Visual       ctermbg=59

" not used in Clojure (left as in wombat)
hi Type			ctermfg=221
hi Statement	ctermfg=117
hi Keyword		ctermfg=117
hi PreProc		ctermfg=173

"JavaScript Highlighting
hi javaScriptParens ctermfg=72
hi javaScriptBraces ctermfg=221

"Extra
hi DiffDelete	ctermfg=15
hi WarningMsg	ctermfg=red
