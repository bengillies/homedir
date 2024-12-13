return {
  {
    'aaronik/treewalker.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      vim.keymap.set('n', '[', ':Treewalker Up<CR>', { noremap = true, silent = true })
      vim.keymap.set('n', ']', ':Treewalker Down<CR>', { noremap = true, silent = true })
      vim.keymap.set('n', '{', ':Treewalker Left<CR>', { noremap = true, silent = true })
      vim.keymap.set('n', '}', ':Treewalker Right<CR>', { noremap = true, silent = true })
    end
  },
}
