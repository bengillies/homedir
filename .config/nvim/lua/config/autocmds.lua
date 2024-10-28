-- Utility function for creating autocommands
local function augroup(name)
  return vim.api.nvim_create_augroup('custom_' .. name, { clear = true })
end

-- use indents of 4 spaces apart from ruby, handlebars and coffeescript, js where we want 2
vim.api.nvim_create_autocmd('FileType', {
  group = augroup('indentation'),
  pattern = { 'ruby', 'coffee', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'mustache' },
  callback = function()
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
  end,
})

-- tabs instead of spaces
-- apart from python, Ruby, Handlebars and CoffeeScript where we want spaces.
vim.api.nvim_create_autocmd('FileType', {
  group = augroup('expandtab'),
  pattern = { 'python', 'ruby', 'coffee', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'mustache' },
  callback = function()
    vim.opt_local.expandtab = true
  end,
})

-- JSON file settings
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  group = augroup('json_files'),
  pattern = '*.json',
  callback = function()
    vim.opt_local.filetype = 'json'
    vim.opt_local.syntax = 'javascript'
  end,
})

-- JSON5 file settings
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  group = augroup('json5_files'),
  pattern = '*.json5',
  callback = function()
    vim.opt_local.filetype = 'javascript'
    vim.opt_local.syntax = 'javascript'
  end,
})

-- ES6 files
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  group = augroup('es6_files'),
  pattern = '*.es6',
  callback = function()
    vim.opt_local.filetype = 'javascript'
  end,
})

-- Markdown files
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  group = augroup('markdown_files'),
  pattern = '*.md',
  callback = function()
    vim.opt_local.filetype = 'markdown'
  end,
})

-- Spelling mistakes
vim.api.nvim_create_autocmd('FileType', {
  group = augroup('spelling_fixes'),
  pattern = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
  callback = function()
    vim.keymap.set('ia', 'retrun', 'return', {})
    vim.keymap.set('ia', 'lenght', 'length', {})
  end,
})

-- Code folding settings
vim.api.nvim_create_autocmd('FileType', {
  group = augroup('folding'),
  pattern = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'css', 'scss' },
  callback = function()
    vim.opt_local.foldmethod = 'marker'
    vim.opt_local.foldmarker = '{,}'
    -- Note: We'll define MarkerFoldText function separately
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = augroup('indent_folding'),
  pattern = { 'python', 'html' },
  callback = function()
    vim.opt_local.foldmethod = 'indent'
  end,
})

-- Remove indenting for JS/Ruby
vim.api.nvim_create_autocmd('FileType', {
  group = augroup('indent_override'),
  pattern = { 'ruby', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
  callback = function()
    vim.opt_local.indentexpr = 'cindent'
  end,
})

-- Relative number toggle based on focus/mode
vim.api.nvim_create_autocmd('FocusLost', {
  group = augroup('numbertoggle'),
  callback = function()
    vim.opt.number = true
    vim.opt.relativenumber = false
  end,
})

vim.api.nvim_create_autocmd('FocusGained', {
  group = augroup('numbertoggle'),
  callback = function()
    vim.opt.relativenumber = true
  end,
})

vim.api.nvim_create_autocmd('InsertEnter', {
  group = augroup('numbertoggle'),
  callback = function()
    vim.opt.number = true
    vim.opt.relativenumber = false
  end,
})

vim.api.nvim_create_autocmd('InsertLeave', {
  group = augroup('numbertoggle'),
  callback = function()
    vim.opt.relativenumber = true
  end,
})

-- Load previous session if it exists and then delete it
vim.api.nvim_create_autocmd('VimEnter', {
  group = augroup('session_load'),
  callback = function()
    local session_file = 'Session.vim'
    if vim.fn.filereadable(session_file) == 1 then
      vim.cmd('source ' .. session_file)
      vim.fn.delete(session_file)
    end
  end,
})

-- Pipe JSON through jq to format
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'json',
  callback = function()
    vim.keymap.set('v', '=', ':!jq .<CR>', { buffer = true })
  end,
})

-- Use prettier to format JS/TS files
vim.api.nvim_create_autocmd('FileType', {
  pattern = {'javascript', 'javascriptreact', 'typescript', 'typescriptreact'},
  callback = function()
    vim.keymap.set('n', '==', function()
      vim.cmd(':!npx prettier -w ' .. vim.fn.expand('%'))
      vim.cmd('edit')
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<CR>', true, true, true), 'n', false)
    end, { buffer = true })
  end
})

-- Define the MarkerFoldText function
-- This is a more complex function that we'll implement in Lua
_G.MarkerFoldText = function()
  local line = vim.fn.getline(vim.v.foldstart)
  local sub = line

  -- Check if it's a comment fold
  if vim.fn.match(line, '^[ \t]*\\(/\\*\\|//\\)[*/\\\\]*[ \t]*$') == 0 then
    local initial = vim.fn.substitute(line, '^\\([ \t]\\)*\\(/\\*\\|//\\)\\(.*\\)', '\\1\\2', '')
    local linenum = vim.v.foldstart + 1

    while linenum < vim.v.foldend do
      line = vim.fn.getline(linenum)
      local comment_content = vim.fn.substitute(line, '^\\([ \t/\\*]*\\)\\(.*\\)$', '\\2', 'g')
      if comment_content ~= '' then
        sub = initial .. ' ' .. comment_content
        break
      end
      linenum = linenum + 1
    end
  else
    -- Handle code blocks
    local startbrace = vim.fn.substitute(line, '^.*{[ \t]*$', '{', 'g')
    if startbrace == '{' then
      line = vim.fn.getline(vim.v.foldend)
      local endbrace = vim.fn.substitute(line, '^[ \t]*}\\(.*\\)$', '}', 'g')
      if endbrace == '}' then
        sub = sub .. vim.fn.substitute(line, '^[ \t]*}\\(.*\\)$', '...}\\1', 'g')
      end
    end
  end

  -- Add the line count
  local lines_count = vim.v.foldend - vim.v.foldstart + 1
  local info = ' ' .. lines_count .. ' lines'
  sub = sub .. string.rep(' ', 100)  -- padding

  -- Calculate width adjustments for line numbers and fold column
  local num_w = vim.wo.number and vim.wo.numberwidth or 0
  local fold_w = vim.wo.foldcolumn
  local win_w = vim.fn.winwidth(0)

  -- Truncate the line if necessary
  local target_width = win_w - #info - num_w - fold_w - 1
  if #sub > target_width then
    sub = string.sub(sub, 1, target_width)
  end

  return sub .. info
end

-- Set up the fold text
vim.opt.foldtext = 'v:lua.MarkerFoldText()'

-- easier quickfix/loclist navigation

-- Function to handle either quickfix or location list commands
local function either_ql_buffer(qfix, loc)
  local win_info = vim.fn.getwininfo(vim.fn.win_getid())[1]
  if win_info.loclist == 1 then
    vim.cmd(loc)
  elseif win_info.quickfix == 1 then
    vim.cmd(qfix)
  end
end

-- Set up autocmd group for quickfix window mappings
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'qf',
  callback = function()
    -- Local mappings for quickfix/location list buffer
    local opts = { buffer = true, noremap = true, silent = true }

    vim.keymap.set('n', '<CR>', function()
      either_ql_buffer(':cc', ':ll')
    end, opts)

    vim.keymap.set('n', '<Esc>', function()
      either_ql_buffer(':ccl', ':lcl')
      vim.cmd('wincmd p')
    end, opts)

    vim.keymap.set('n', '<S-j>', function()
      either_ql_buffer('cnext', 'lnext')
      vim.cmd('wincmd p')
    end, opts)

    vim.keymap.set('n', '<S-k>', function()
      either_ql_buffer('cprevious', 'lprevious')
      vim.cmd('wincmd p')
    end, opts)
  end,
})

-- Global mapping to refocus on quickfix/location list
vim.keymap.set('n', '<Space>q', '<C-w>p', { noremap = true, silent = true })
