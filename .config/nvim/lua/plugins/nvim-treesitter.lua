return {
  {
    'nvim-treesitter/nvim-treesitter',
    -- `main` is a full rewrite. The `master` branch is locked to Nvim 0.11 and
    -- breaks on 0.12 (its query directives still use the removed `all = false`
    -- calling convention, so `get_node_text` is handed a node *list*).
    branch = 'main',
    lazy = false, -- the `main` branch does not support lazy-loading
    build = ':TSUpdate',
    config = function()
      local ts = require('nvim-treesitter')

      ts.setup {}

      ts.install {
        'javascript',
        'typescript',
        'json',
        'json5',
        'python',
        'css',
        'scss',
        'markdown_inline',
      }

      -- `main` no longer enables highlighting itself; Neovim does it.
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })
    end
  },
}
