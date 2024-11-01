return {
  'gbprod/nord.nvim',
  lazy = false,
  config = function()
    require("nord").setup({})
    vim.cmd.colorscheme("nord")
  end,
  install = {
    colorscheme = { "nord" },
  },
}
