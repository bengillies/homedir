return {
  {
    'bling/vim-airline',
    init = function()
      -- add a status line
      vim.opt.laststatus = 2

      -- tell airline to use fancy font rendering
      vim.g.airline_powerline_fonts = 1

      -- customise the statusline
      -- a=mode
      -- b=branch
      -- c=filename
      -- x=tag + filetype
      -- y=file encoding
      -- z=percentage + line number
      vim.g["airline#extensions#default#layout"] = {
        { 'a', 'c' },
        { 'x', 'error', 'warning' }
      }
    end
  }
}
