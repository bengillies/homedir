return {
  -- Main Telescope plugin
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'octarect/telescope-menu.nvim',
      'nvim-telescope/telescope-fzy-native.nvim',
      'nvim-telescope/telescope-file-browser.nvim',
    },
    config = function()
      local telescope = require('telescope')
      local actions = require('telescope.actions')
      local action_state = require("telescope.actions.state")
      local fb_actions = require("telescope").extensions.file_browser.actions

      telescope.setup({
        defaults = {
          prompt_prefix = '> ',
          sorting_strategy = "ascending",
          layout_strategy = "flex",
          layout_config = {
            preview_cutoff = 1,
            horizontal = { mirror = false },
            vertical = { mirror = false },
          },
          file_ignore_patterns = { ".git/", "node_modules/" },
          mappings = {
            i = {
              ['<C-j>'] = actions.move_selection_next,
              ['<C-k>'] = actions.move_selection_previous,
              ['<C-h>'] = actions.select_horizontal,
              ["<CR>"] = function(prompt_bufnr)
                local actions = require("telescope.actions")
                local state = require("telescope.actions.state")
                local selection = state.get_selected_entry()

                if selection == nil then
                    actions.close(prompt_bufnr)
                    return
                end

                -- Get full paths for comparison
                local selected_file = vim.fn.fnamemodify(selection.filename, ':p')

                -- Check all windows in all tabs
                for _, tabnr in ipairs(vim.api.nvim_list_tabpages()) do
                    for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(tabnr)) do
                        local bufnr = vim.api.nvim_win_get_buf(winid)
                        local buf_name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ':p')

                        if buf_name == selected_file then
                            actions.close(prompt_bufnr)
                            -- Switch to the tab containing the window
                            vim.api.nvim_set_current_tabpage(tabnr)
                            -- Switch to the window
                            vim.api.nvim_set_current_win(winid)
                            return
                        end
                    end
                end

                -- If not found, open in current buffer
                actions.close(prompt_bufnr)
                if (selection.action) then
                  selection.action(selection)
                  return;
                end

                vim.cmd('edit ' .. selection.filename)
              end,
            },
            n = {
              h = actions.select_horizontal,
              ["<CR>"] = function(prompt_bufnr)
                local actions = require("telescope.actions")
                local state = require("telescope.actions.state")
                local selection = state.get_selected_entry()

                if selection == nil then
                    actions.close(prompt_bufnr)
                    return
                end

                -- Get full paths for comparison
                local selected_file = vim.fn.fnamemodify(selection.filename, ':p')

                -- Check all windows in all tabs
                for _, tabnr in ipairs(vim.api.nvim_list_tabpages()) do
                    for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(tabnr)) do
                        local bufnr = vim.api.nvim_win_get_buf(winid)
                        local buf_name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ':p')

                        if buf_name == selected_file then
                            actions.close(prompt_bufnr)
                            -- Switch to the tab containing the window
                            vim.api.nvim_set_current_tabpage(tabnr)
                            -- Switch to the window
                            vim.api.nvim_set_current_win(winid)
                            return
                        end
                    end
                end

                -- If not found, open in current buffer
                actions.close(prompt_bufnr)
                if (selection.action) then
                  selection.action(selection)
                  return;
                end
                vim.cmd('edit ' .. selection.filename)
              end,
            },
          },
        },
        pickers = {
          -- File browser configuration
          find_files = {
            theme = "ivy",
          },
          buffers = {
            theme = "ivy",
          },
          live_grep = {
            theme = "ivy",
          },
          lsp_document_symbols = {},
        },
        extensions = {
          fzy_native = {
            override_generic_sorter = true,
            override_file_sorter = true,
          },
          file_browser = {
            initial_mode = 'normal',
            theme = "ivy",
            mappings = {
              ['i'] = {
                ['<C-o>'] = fb_actions.create,
                ['<CR>'] = actions.select_default,
              },
              ['n'] = {
                ['o'] = fb_actions.create,
                ['<CR>'] = actions.select_default,
              },
            },
          },
          menu = {
            initial_mode = 'normal',
            default = {
              items = {
                { "Show all errors", "Telescope diagnostics" },
                { "Rename symbol", "lua vim.lsp.buf.rename()" },
                { "Show references", "Telescope lsp_references" },
                { "Chat code", "!code -g " .. vim.fn.expand("%") .. ":" .. vim.fn.line(".") .. ":" .. vim.fn.col(".") },
                { "Suggest code", ":Copilot panel" },
                { "Perform action", "lua vim.lsp.buf.code_action()" },
              },
            },
            mappings = {
              ['i'] = {
                ['<CR>'] = function(prompt_bufnr)
                  local selection = action_state.get_selected_entry()
                  actions.close(prompt_bufnr)
                  vim.cmd(entry.cmd)
                end,
              },
              ['n'] = {
                ['<CR>'] = function(prompt_bufnr)
                  local selection = action_state.get_selected_entry()
                  actions.close(prompt_bufnr)
                  vim.cmd(entry.cmd)
                end,
              },
            },
          },
        },
      })

      -- Load Telescope extensions
      telescope.load_extension('fzy_native')
      telescope.load_extension('menu')
      telescope.load_extension('file_browser')

      vim.keymap.set("n", "<Leader>f", "<cmd>Telescope find_files<CR>", { noremap = true, silent = true })  -- Find files
      vim.keymap.set("n", "<Leader>F", "<cmd>Telescope file_browser path=%:p:h<CR>", { silent = true }) -- File browser
      vim.keymap.set("n", "<Space>g", "<cmd>Telescope live_grep<CR>", { noremap = true, silent = true }) -- Grep across files
      vim.keymap.set("n", "<Leader>b", "<cmd>Telescope buffers<CR>", { noremap = true, silent = true }) -- Search open buffers
      vim.keymap.set("n", "<Leader>y", "<cmd>Telescope registers<CR>", { noremap = true, silent = true }) -- Registers for yank history
      vim.keymap.set("n", "<Leader><Leader>", function() require("telescope.builtin").current_buffer_fuzzy_find({ default_text = vim.fn.expand("<cword>") }) end, { noremap = true, silent = true })  -- Fuzzy find in current buffer
      vim.keymap.set("v", "<Leader><Leader>", function()
        vim.cmd('normal! y')
        local selected_text = vim.fn.getreg('"')

        require("telescope.builtin").current_buffer_fuzzy_find({
            default_text = selected_text
        })
      end, { silent = true }) -- Fuzzy find with visual selection
      vim.keymap.set("n", "<F7>", "<cmd>Telescope lsp_document_symbols<CR>", { noremap = true, silent = true }) -- Outline current file

      vim.keymap.set("n", "<Space>a", "<cmd>Telescope menu<CR>", { silent = true })
    end,
  },
}
