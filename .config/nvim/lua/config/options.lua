-- set timeout to speed vim up
vim.opt.timeout = false
vim.opt.ttimeout = true
vim.opt.timeoutlen = 50

-- minimum number of lines to keep above and below the cursor
vim.opt.scrolloff = 2

-- turn on line numbers
vim.opt.number = true

-- turn on the ruler
vim.opt.ruler = true

-- autocomplete
vim.opt.wildmode = "list:longest,full"
vim.opt.completeopt = "menu,menuone,noselect,preview"

-- wrap long lines
vim.opt.wrap = true

-- auto indent new lines
vim.opt.autoindent = true
vim.opt.smartindent = true

-- use 4 spaces by default
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

-- tabs instead of spaces by default
vim.opt.expandtab = false

-- show trailing whitespace and spaces before a tab
vim.fn.matchadd('ErrorMsg', [[\s\+$\| \+\ze\t]])

-- set colorcolumn
vim.opt.colorcolumn = '80'
vim.api.nvim_set_hl(0, 'ColorColumn', { ctermbg = 0 })

-- set the encoding
vim.opt.encoding = 'utf-8'

-- ignore these file types when opening
vim.opt.wildignore = { '*.pyc', '*.o', '*.obj', '*.swp' }

-- show search results as you type
vim.opt.incsearch = true

-- highlight all search matches
vim.opt.hlsearch = true

-- set the backspace key to include new lines, tabs, etc
vim.opt.backspace = { 'indent', 'eol', 'start' }

-- Appearance
vim.opt.termguicolors = true
vim.env.TERM = 'screen-256color'
vim.opt.background = "dark"
vim.opt.signcolumn = "no"
vim.opt.list = true
vim.opt.listchars = {
  tab = "▸ ",
  trail = "·",
}

-- Cursor line
vim.opt.cursorline = true
vim.opt.cursorcolumn = true

-- disable the bell
vim.opt.visualbell = false

-- Set fold settings
vim.opt.foldmethod = "marker"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true
vim.api.nvim_set_hl(0, 'Folded', { ctermfg = 'Grey', ctermbg = 0 })
