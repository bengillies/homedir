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
          enabled = false,
          keymap = {
            accept = '<F5>',
            next = '<F6>',
            dismiss = '<Esc>',
          },
        },
        suggestion = {
          hide_during_completion = false,
          enabled = true,
          auto_trigger = true,
          keymap = {
            accept = '<M-Tab>',
            accept_word = '<M-BS>',
          },
        },
        copilot_model = 'gpt-41-copilot',
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
