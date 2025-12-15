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
      })
    end
  },
}
