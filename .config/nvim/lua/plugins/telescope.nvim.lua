return {
  -- Main Telescope plugin
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'octarect/telescope-menu.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      'nvim-telescope/telescope-file-browser.nvim',
      'nvim-telescope/telescope-ui-select.nvim',
      'olimorris/codecompanion.nvim',
    },
    config = function()
      local telescope = require('telescope')
      local actions = require('telescope.actions')
      local action_state = require("telescope.actions.state")
      local fb_actions = require("telescope").extensions.file_browser.actions

      -- use existing buffers if the file is already open
      function custom_selection_handler(prompt_bufnr)
          local actions = require("telescope.actions")
          local state = require("telescope.actions.state")
          local selection = state.get_selected_entry()

          if selection == nil then
              actions.close(prompt_bufnr)
              return
          end

          -- If the selection has an action property, execute it
          if selection.action then
            actions.close(prompt_bufnr)
            selection.action(selection)
            return
          end

          -- If the selection doesn't have a filename, perform default action
          if not selection.filename then
            return actions.select_default(prompt_bufnr)
          end

          -- Get full paths for comparison
          local selected_file = vim.fn.fnamemodify(selection.filename, ':p')
          local current_buffer = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(vim.fn.bufnr('#')), ':p')

          -- Check if the selected file is the same as the current buffer
          if selected_file == current_buffer then
              return actions.select_default(prompt_bufnr)
          end

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
      end

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
              ["<CR>"] = custom_selection_handler,
            },
            n = {
              h = actions.select_horizontal,
              ["<CR>"] = custom_selection_handler,
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
          lsp_references = {
            initial_mode = 'normal',
            jump_type = "never",
          },
          lsp_type_definitions = {
            initial_mode = 'normal',
            jump_type = "never",
          },
          lsp_code_actions = {
            initial_mode = 'normal',
            jump_type = "never",
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
          file_browser = {
            initial_mode = 'normal',
            theme = "ivy",
            mappings = {
              ['i'] = {
                ['<C-o>'] = fb_actions.create,
              },
              ['n'] = {
                ['o'] = fb_actions.create,
              },
            },
          },
          menu = {
            initial_mode = 'normal',
            default = {
              items = {
                { "Show all errors", "Telescope diagnostics" },
                { "Rename symbol", "lua vim.lsp.buf.rename()" },
                { "Show type definition", "Telescope lsp_references" },
                { "Show references", "Telescope lsp_references" },
                { "LSP action", "lua vim.lsp.buf.code_action()" },
                { "AI action", ":CodeCompanionActions" },
                { "Chat buffer", ":CodeCompanionChat Toggle" },
                { "Add types", ":CodeCompanion /type" },
                { "Explain code", ":CodeCompanion /explain" },
                { "Fix bugs", ":CodeCompanion /fix" },
                { "Add Doc strings", ":CodeCompanion /doc_string" },
                { "Fix Diagnostics", ":CopilotChatFixDiagnostic" },
                { "Optimise code", ":CopilotChatOptimize" },
                { "Review code", ":CopilotChatReview" },
                { "Write tests", ":CopilotChatTests" },
              },
            },
            mappings = {
              ['i'] = {
                ['<CR>'] = function(prompt_bufnr)
                  actions.close(prompt_bufnr)
                  vim.cmd(entry.cmd)
                end,
              },
              ['n'] = {
                ['<CR>'] = function(prompt_bufnr)
                  actions.close(prompt_bufnr)
                  vim.cmd(entry.cmd)
                end,
              },
            },
          },
          ['ui-select'] = {},
        },
      })

      -- Load Telescope extensions
      telescope.load_extension('fzf')
      telescope.load_extension('menu')
      telescope.load_extension('file_browser')
      telescope.load_extension('ui-select')

      vim.keymap.set("n", "<Leader>f", "<cmd>Telescope find_files<CR>", { noremap = true, silent = true })  -- Find files
      vim.keymap.set("n", "<Leader>F", "<cmd>Telescope file_browser path=%:p:h<CR>", { silent = true }) -- File browser
      vim.keymap.set("n", "<Space>g", "<cmd>Telescope live_grep<CR>", { noremap = true, silent = true }) -- Grep across files
      vim.keymap.set("n", "<Leader>b", "<cmd>Telescope buffers<CR>", { noremap = true, silent = true }) -- Search open buffers
      vim.keymap.set("n", "<Leader>y", "<cmd>Telescope registers<CR>", { noremap = true, silent = true }) -- Registers for yank history
      vim.keymap.set("n", "<Leader><Leader>", function() require("telescope.builtin").current_buffer_fuzzy_find({ default_text = "'" .. vim.fn.expand("<cword>") }) end, { noremap = true, silent = true })  -- Fuzzy find in current buffer
      vim.keymap.set("v", "<Leader><Leader>", function()
        vim.cmd('normal! y')
        local selected_text = vim.fn.getreg('"')

        require("telescope.builtin").current_buffer_fuzzy_find({
            default_text = "'" .. selected_text
        })
      end, { silent = true }) -- Fuzzy find with visual selection
      vim.keymap.set("n", "<F7>", "<cmd>Telescope lsp_document_symbols<CR>", { noremap = true, silent = true }) -- Outline current file

      vim.keymap.set({ "n", "v" }, "<Space>a", "<cmd>Telescope menu<CR>", { silent = true })
    end,
  },
}
