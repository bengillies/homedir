return {
  {
    'bengillies/vim-slime',
    init = function()
      -- Set Slime to use tmux
      vim.g.slime_target = "tmux"

      -- Remove Slime's default key mappings
      vim.g.slime_no_mappings = 1

      -- Set up custom keybindings for Slime
      vim.keymap.set("x", "<C-e>", "<Plug>SlimeRegionSend", { silent = true })
      vim.keymap.set("n", "<C-e>", "<Plug>SlimeMotionSend", { silent = true })
      vim.keymap.set("n", "<C-e><C-e>", "<Plug>SlimeLineSend", { silent = true })
      vim.keymap.set("n", "<leader>v", "<Plug>SlimeConfig", { silent = true })
    end
  }
}
