return {
  'morhetz/gruvbox',
  lazy = false,
  config = function()
    vim.cmd.colorscheme("gruvbox")
  end,
  install = {
    colorscheme = { "gruvbox" },
  },
}
