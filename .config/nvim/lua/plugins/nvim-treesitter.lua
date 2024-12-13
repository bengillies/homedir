return {
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
    },
    build = ':TSUpdate',
    config = function()
      require'nvim-treesitter.configs'.setup {
        ensure_installed = {
          "javascript",
          "typescript",
          "json",
          "json5",
          "python",
          "css",
          "scss",
          "markdown_inline",
        },
        highlight = {
          enable = true,
        },
      }
    end
  },
}

