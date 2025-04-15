return {
  "gbprod/yanky.nvim",
  opts = {
    ring = {
      history_length = 20,
      storage = "memory",
    },
    system_clipboard = {
      clipboard_register = "+",
    },
  },
  keys = {
    { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank text" },
    { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put yanked text after cursor" },
    { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put yanked text before cursor" },
    { "<m-y>", "<Plug>(YankyPreviousEntry)", desc = "Select previous entry through yank history" },
    { "<m-Y>", "<Plug>(YankyNextEntry)", desc = "Select next entry through yank history" },
  },
}
