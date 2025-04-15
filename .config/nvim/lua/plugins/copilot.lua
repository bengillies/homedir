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
        },
        copilot_model = 'gpt-4o-copilot',
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
    branch = 'main',
    config = function()
      require('CopilotChat').setup({
        model = "claude-3.7-sonnet", -- claude-3.7-sonnet-thought
        mappings = {
          close = {
            normal = '<Esc><Esc>',
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
