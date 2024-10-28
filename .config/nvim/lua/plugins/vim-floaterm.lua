-- Replace vim style :!ls with :T ls (or :! ls) as neovim dropped support for
-- proper terminal integration

return {
  {
    'voldikss/vim-floaterm',
    lazy = false,
    init = function()
      -- big float in the centre
      vim.g.floaterm_width = 0.8
      vim.g.floaterm_height = 0.8
      vim.g.floaterm_position = 'center'

      -- back to normal mode then close on multiple escape
      vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { silent = true })
      vim.api.nvim_create_autocmd('TermOpen', {
        callback = function()
          vim.keymap.set('n', '<Esc>', ':FloatermToggle<CR>', { buffer = true, silent = true })
        end
      })

      -- open command mode abbreviation when typing e.g. :! ls -> :T ls (note the space)
      vim.api.nvim_create_user_command('T', function(opts)
        vim.cmd('FloatermToggle')

        if opts.args == '' then
          return
        end

        vim.cmd('FloatermSend ' .. opts.args)
      end, { nargs = '*' })

      -- command mode abbreviation to send command to terminal and open it
      vim.keymap.set('ca', '!', "getcmdtype() == ':' && getcmdline() =~ '^!' ? 'T' : '!'", { expr = true })
    end
  }
}

