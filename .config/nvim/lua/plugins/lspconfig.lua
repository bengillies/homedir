return {
  {
    'neovim/nvim-lspconfig',
    config = function()
      local lspconfig = require('lspconfig')

      -- attach keybindings, etc on LSP attach
      local common_config = function(client, bufnr)
        local opts = {
          silent = true,
          buffer = bufnr,
        }

        -- display type information under cursor (NUL maps to C-Space)
        vim.keymap.set('n', '<C-Space>', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
        vim.keymap.set('n', '<NUL>', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)

        -- open quickfix with all references to variable in
        vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.references()<CR>', opts)

        -- jump to definition
        vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)

        -- code actions
        vim.keymap.set('n', '<C-s>', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
        vim.keymap.set('v', '<C-s>', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)

        -- add missing imports
        vim.keymap.set('n', '<Leader>a', function()
          vim.lsp.buf.code_action({
              filter = function(action)
                  -- Different LSP servers use different action titles
                  return action.title:find('Import') ~= nil
                      or action.title:find('Add all missing imports') ~= nil
                      or action.title:find('Add missing imports') ~= nil
                      or action.title:find('Update import') ~= nil
                      or action.kind == 'source.addMissingImports'
                      or action.kind == 'source.addMissingImports.ts'
              end,
              apply = true
          })
        end, { silent = true })

        -- errors/diagnostics

        -- settings
        vim.diagnostic.config({
            virtual_text = false,
            signs = true,
            underline = true,
            update_in_insert = false,
            severity_sort = true,
            float = {
              focusable = false,
              border = 'rounded',
              source = 'always',
              prefix = ' ',
              scope = 'line',
            },
        })

        -- next/prev diagnostic
        vim.keymap.set('n', '<C-e><C-n>', function()
            vim.diagnostic.goto_next({
              float = false,
              severity = {
                  min = vim.diagnostic.severity.HINT
              }
            })
        end, { silent = true })

        vim.keymap.set('n', '<C-e><C-p>', function()
            vim.diagnostic.goto_prev({
              float = false,
              severity = {
                  min = vim.diagnostic.severity.HINT
              }
            })
        end, { silent = true })

        local function show_line_diagnostics()
            vim.diagnostic.open_float()
        end

        -- Show line diagnostics on <C-e><C-Space>
        vim.keymap.set('n', '<C-e><C-Space>', show_line_diagnostics, { silent = true })
        vim.keymap.set('n', '<C-e><NUL>', show_line_diagnostics, { silent = true })

        -- show diagnostics in line number column
        for _, diag in ipairs({ "Error", "Warn", "Info", "Hint" }) do
            vim.fn.sign_define("DiagnosticSign" .. diag, {
                text = "",
                texthl = "DiagnosticSign" .. diag,
                linehl = "",
                numhl = "DiagnosticSign" .. diag,
            })
        end
      end

      -- goto definition in a split unless the definition is in the same file, or an already open buffer
      local function goto_definition(split_cmd)
          local util = vim.lsp.util
          local log = require("vim.lsp.log")
          local api = vim.api

          -- Helper function to get buffer number from URI
          local function uri_to_bufnr(uri)
              return vim.uri_to_bufnr(uri)
          end

          -- Helper function to find window containing buffer
          local function find_window_with_buffer(bufnr)
              for _, win in ipairs(api.nvim_list_wins()) do
                  if api.nvim_win_get_buf(win) == bufnr then
                      return win
                  end
              end
              return nil
          end

          -- Helper function to handle the jump with proper offset encoding
          local function handle_location(location, client_id)
              local client = vim.lsp.get_client_by_id(client_id)
              if not client then
                  vim.notify("LSP client not found", vim.log.levels.ERROR)
                  return
              end

              local uri = location.uri or location.targetUri
              local range = location.range or location.targetRange

              -- Get buffer number for the target location
              local target_bufnr = uri_to_bufnr(uri)
              local current_bufnr = api.nvim_get_current_buf()

              -- If target is in current buffer, just jump
              if target_bufnr == current_bufnr then
                  util.jump_to_location(location, client.offset_encoding)
                  return
              end

              -- Check if target buffer is already open in a window
              local existing_win = find_window_with_buffer(target_bufnr)
              if existing_win then
                  -- Switch to existing window
                  api.nvim_set_current_win(existing_win)
                  util.jump_to_location(location, client.offset_encoding)
                  return
              end

              -- If we get here, we need to open in a new split
              if split_cmd then
                  vim.cmd(split_cmd)
              else
                  -- Default to vertical split if no split command provided
                  vim.cmd("vsplit")
              end

              util.jump_to_location(location, client.offset_encoding)
          end

          -- Main handler function
          local handler = function(_, result, ctx)
              if result == nil or vim.tbl_isempty(result) then
                  local _ = log.info() and log.info(ctx.method, "No location found")
                  return nil
              end

              local client = vim.lsp.get_client_by_id(ctx.client_id)
              if not client then
                  vim.notify("LSP client not found", vim.log.levels.ERROR)
                  return
              end

              -- Handle single location
              if not vim.tbl_islist(result) then
                  handle_location(result, ctx.client_id)
                  return
              end

              -- Always just handle the first location
              handle_location(result[1], ctx.client_id)
          end

          return handler
      end

      local handlers =  {
        ["textDocument/hover"] =  vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded", }),
        ["textDocument/signatureHelp"] =  vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
        ["textDocument/definition"] = goto_definition('split'),
      }

      -- load lsp servers
      --[[
npm install -g pyright
npm install -g typescript typescript-language-server
npm install -g vscode-langservers-extracted
npm install -g bash-language-server
npm install -g vim-language-server
brew install lua-language-server
      --]]

      local servers = {
        'pyright',
        'ts_ls',
        'lua_ls',
        'cssls',
        'bashls',
        'vimls'
      }

      for _, lsp in ipairs(servers) do
        lspconfig[lsp].setup{
          on_attach = common_config,
          handlers = handlers,
        }
      end
    end
  }
}
