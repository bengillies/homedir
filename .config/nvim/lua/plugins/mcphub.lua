return {
  "ravitemer/mcphub.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  build = "npm install -g mcp-hub@latest",
  config = function()
    require("mcphub").setup({
      port = 8324,
      config = vim.fn.expand("~/.mcpservers.json"),  -- homedir to keep out of repo

      on_ready = function(hub)
      end,
      on_error = function(err)
        if err then
          vim.notify(err, vim.log.levels.ERROR)
        end
      end,
      log = {
        level = vim.log.levels.WARN,
        to_file = false,
        file_path = nil,
        prefix = "MCPHub"
      },
    })
  end
}
