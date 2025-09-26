return {
  {
    'zbirenbaum/copilot.lua',
    dependencies = {
      "copilotlsp-nvim/copilot-lsp"
    },
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
      vim.g.copilot_nes_debounce = 500

      require('copilot').setup({
        nes = {
          enabled = true,
          keymap = {
            accept = '<M-Tab>',
            next = '<M-S-Tab>',
          },
        },
        suggestion = {
          hide_during_completion = false,
          enabled = true,
          auto_trigger = true,
          keymap = {
            accept = '<M-Tab>',
          },
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
