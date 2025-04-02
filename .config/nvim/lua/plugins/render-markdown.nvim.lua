return {
  {
    'echasnovski/mini.icons',
    config = function()
      require('mini.icons').setup()
    end,
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    ft = { "markdown", "codecompanion", "copilot-chat" },
    config = function()
      require('render-markdown').setup({
        heading = {
          position = 'inline',
          backgrounds = {},
        },
      })
    end
  }
}
