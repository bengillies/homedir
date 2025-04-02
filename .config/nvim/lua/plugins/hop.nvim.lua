return {
  "smoka7/hop.nvim",
  version = "*",
  opts = {
    keys = 'etovxqpdygfblzhckisuran'
  },
  config = function()
    local hop = require("hop")

    hop.setup({})

    vim.keymap.set('n', 's', function()
      hop.hint_char1({});
    end)

    vim.keymap.set('v', 's', function()
      hop.hint_char1({});
    end)

    vim.keymap.set('n', 'S', function()
      hop.hint_char1({ multi_windows = true })
    end)

    vim.keymap.set('v', 'S', function()
      hop.hint_char1({ multi_windows = true })
    end)
  end
}
