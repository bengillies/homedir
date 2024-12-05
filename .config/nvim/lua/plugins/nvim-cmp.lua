return {
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'zbirenbaum/copilot-cmp',
    },
    config = function()
      local cmp = require'cmp'
      cmp.setup({
        window = {
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<CR>'] = cmp.mapping.confirm({}),
        }),
        sources = cmp.config.sources({
          { name = 'copilot' },
          { name = 'nvim_lsp' },
          { name = 'buffer' },
        })
      })

      require('copilot_cmp').setup()

      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'markdown',
        callback = function()
          cmp.setup.buffer({
            completion = { autocomplete = false }
          })
        end,
      })
    end
  }
}
