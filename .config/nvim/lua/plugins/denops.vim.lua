return {
  {
    'vim-denops/denops.vim',
    dependencies = { 'vim-denops/denops-shared-server.vim' },
    init = function()
      -- Manual command to restart shared deno server when it becomes unresponsive
      vim.api.nvim_create_user_command("RestartDeno", function()
          vim.cmd("!launchctl stop io.github.vim-denops.LaunchAtLogin && launchctl start io.github.vim-denops.LaunchAtLogin")
      end, {})

      -- set shared deno server address
      vim.g['denops_server_addr'] = '127.0.0.1:32123'
    end
  }
}
