return {
  {
    "ibhagwan/fzf-lua",
    dependencies = { "echasnovski/mini.icons" },
    config = function()
      local fzf = require('fzf-lua')

      -- remove icons, etc from file names
      local function sanitize(text)
        local s = text:gsub("^%s+", "")
        s = s:gsub("[^%w%p ]+", "")
        return s
      end

      local function openFile(file)
        print(file)
        if vim.bo.modified then
          local choice = vim.fn.input("Unsaved changes. Open new file? (y/n): ")
          if choice:lower() ~= 'y' then
            return
          end
        end

        for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
          local bufnr = vim.api.nvim_win_get_buf(winid)
          local bufname = vim.api.nvim_buf_get_name(bufnr)
          if bufname == vim.fn.fnamemodify(file, ':p') then
            vim.api.nvim_set_current_win(winid)
            print("Switched to already open file: " .. file)
            return
          end
        end

        vim.cmd('edit ' .. file)
      end

      fzf.setup({
        files = {
          prompt = 'Files❯ ',
          git_icons = true,
          file_icons = true,
          cwd_only = false,
          hidden = true,
          fd_opts = '--strip-cwd-prefix --ignore-file .gitignore --type f',
          actions = {
            ['default'] = function(selected)
              openFile(sanitize(selected[1]))
            end
          },
        },
        grep = {
          prompt = 'Grep❯ ',
          rg_opts = '--vimgrep --no-heading --smart-case --ignore-file .gitignore --glob "!*test*"',
          grep_open_files = false,
        },
        buffers = {
          prompt = 'Buffers❯ ',
          sort_lastused = true
        },
        registers = {
          prompt = 'Registers❯ '
        },
        blines = {
          prompt = 'Lines❯ '
        },
        lsp = {
          prompt_postfix = '❯ ',
          cwd_only = false,
          includeDeclaration = true
        },
        code_actions = {
          prompt = 'Code Actions❯ ',
          previewer = 'codeaction'
        },
        finder = {
          prompt = 'LSP Finder❯ '
        },
        fzf_colors = true,
        keymap = {
          fzf = {
            true,
            ['ctrl-d'] = 'half-page-down',
            ['ctrl-u'] = 'half-page-up',
          }
        },
      })

      fzf.register_ui_select()

      -- Combined menu
      local menu_items = {
        { "Show all errors", "FzfLua diagnostics_document" },
        { "Rename symbol", "lua vim.lsp.buf.rename()" },
        { "All FzfLua", "FzfLua builtin" },
        { "LSP action", "FzfLua lsp_code_actions" },
        { "AI Agents", ":CodeCompanionActions" },
        { "Chat buffer", ":CodeCompanionChat Toggle" },
        { "Add types", ":CodeCompanion /type" },
        { "Explain code", ":CodeCompanion /explain" },
        { "Fix bugs", ":CodeCompanion /fix" },
        { "Add Doc strings", ":CodeCompanion /doc_string" },
        { "Fix Diagnostics", ":CopilotChatFixDiagnostic" },
        { "Optimise code", ":CopilotChatOptimize" },
        { "Review code", ":CopilotChatReview" },
        { "Write tests", ":CopilotChatTests" },
      }

      local function custom_menu()
        local labels = vim.tbl_map(function(it) return it[1] end, menu_items)
        fzf.fzf_exec(labels, { prompt = 'Menu❯ ', actions = {
          ['default'] = function(selected)
            for _, item in ipairs(menu_items) do
              if item[1]==selected[1] then
                vim.cmd('normal! gv')
                vim.cmd(item[2])
              end
            end
          end,
        } })
      end

      -- Custom file browser using files provider
      local function file_browser(current_dir)
        local cwd = current_dir or vim.fn.expand('%:p:h')
        cwd = cwd:gsub('[\\/]+$','')
        fzf.files({
          prompt = 'Browser❯ ',
          cwd = cwd,
          hidden = true,
          fd_opts = '--max-depth 1 --strip-cwd-prefix',
          header = "<C-p> to go up a directory, <C-o> to create a new file",
          actions = {
            ['default'] = function(selected)
              -- fzf.files returns selection as a table of items
              local name = sanitize(selected[1])
              local path = cwd .. '/' .. name
              if vim.fn.isdirectory(path) == 1 then
                file_browser(path)
              else
                openFile(vim.fn.fnameescape(path))
              end
            end,
            ['ctrl-p'] = function()
              -- go up to parent directory
              local parent = vim.fn.fnamemodify(cwd, ':h')
              file_browser(parent)
            end,
            ['ctrl-o'] = function()
              local fname = vim.fn.input('New file in ' .. cwd .. '/: ')
              if fname and fname ~= '' then
                local newpath = cwd .. '/' .. fname
                vim.cmd('edit ' .. vim.fn.fnameescape(newpath))
              end
            end,
          },
        })
      end

      local map = vim.keymap.set
      local opts = { noremap=true, silent=true }

      local utils = require "fzf-lua.utils"

      -- Leader-based mappings
      map('n','<Leader>f',fzf.files,opts)
      map('n','<Leader>F',file_browser,opts)
      map('n','<Space>g',fzf.live_grep,opts)
      map('n','<Leader>b',fzf.buffers,opts)
      map('n','<Leader>y',fzf.registers,opts)
      map('n','<Leader><Leader>', function()
        local cWORD = [[(^|\s)]] .. utils.rg_escape(vim.fn.expand("<cWORD>")) .. [[($|\s)]]
        fzf.lgrep_curbuf({ search = cWORD, no_esc = true })
      end,opts)
      map('v','<Leader><Leader>',function()
        vim.cmd('normal! y')
        local sel = vim.fn.getreg('"'):gsub('[\n]+', '')

        fzf.lgrep_curbuf({ search = sel, })
      end,opts)
      map({'n','v'},'<Space>a', custom_menu, opts)
      -- Show document symbols (no search)
      map('n','<F7>',fzf.lsp_document_symbols, opts)
    end
  },
}
