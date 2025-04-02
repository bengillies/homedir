return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "ravitemer/mcphub.nvim",
  },
  config = true,
  opts = {
    strategies = {
      chat = {
        adapter = "copilot",
        tools = {
          ["mcp"] = {
            callback = function() return require("mcphub.extensions.codecompanion") end,
            description = "Call tools and resources from the MCP Servers",
            opts = {
              requires_approval = true,
            }
          }
        }
      },
      inline = {
        adapter = "copilot",
      },
    },
  },
}
