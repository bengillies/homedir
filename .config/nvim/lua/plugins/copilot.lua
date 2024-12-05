return {
  {
    'zbirenbaum/copilot.lua',
    dependencies = {
    },
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup({
        suggestion = {
          enabled = false,
        }
      })

      require('CopilotChat').setup({
      })
    end
  },
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    dependencies = {
      'zbirenbaum/copilot.lua',
      'nvim-lua/plenary.nvim',
    },
    branch = 'canary',
    config = function()
      require('CopilotChat').setup({
        mappings = {
          close = {
            normal = '<Esc>',
          },
          reset = {
            normal = '<C-c>',
            insert = '<C-c>',
          },
        },
      })
    end
  }
}
