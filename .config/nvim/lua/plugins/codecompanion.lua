return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "ravitemer/mcphub.nvim",
    "Davidyz/VectorCode",
  },
  config = function()
      require('codecompanion').setup({
      display = {
        chat = {
          intro_mesage = '',
          start_in_insert_mode = true,
          auto_scroll = false,
        },
      },
      extensions = {
        vectorcode = {
          add_tool = true,
          add_slash_command = true,
          tool_opts = {},
        },
        mcphub = {
          callback = "mcphub.extensions.codecompanion",
          opts = {
            make_vars = true,
            make_slash_commands = true,
            auto_approve = false,
          }
        },
      },
      adapters = {
        openai = function()
          return require("codecompanion.adapters").extend("openai", {
            schema = {
              model = {
                default = "claude-3.7-sonnet", -- claude-3.7-sonnet-thought
              },
            },
          })
        end,
      },
      strategies = {
        chat = {
          adapter = "copilot",
          keymaps = {
            close = {
              modes = {
                n = '<Esc><Esc>',
                i = '<C-c><C-c>',
              },
            },
          },
        },
        inline = {
          adapter = "copilot",
        },
      },
      prompt_library = {
        ['Add Types'] = {
          strategy = 'inline',
          description = 'Add types to the code',
          opts = {
            modes = { 'v' },
            short_name = 'type',
            auto_submit = true,
          },
          prompts = {
            {
              role = 'system',
              content = function(context)
                return 'You are a highly skilled ' .. context.filetype .. ' developer.' .. [[
  Your sole task is to take the provided code snippet — which might lack explicit type annotations — and enhance it by adding proper types everywhere they are appropriate.
  Follow these strict guidelines:
  1. Analyze function declarations, parameters, return types, variable declarations, and object literals.
  2. Insert explicit types based on the context. For functions, add types for all parameters and a return type. For variables, infer and annotate the type where possible.
  3. If a type cannot be confidently inferred either leave it out (preferred), or if that would cause a type error, use 'any' (or equivalent) as a fallback, but strive to avoid it if you can suggest a more specific type.
  4. Ensure that the final output is valid code and typed correctly. Do not alter code that already has proper types unless a correction is needed.
  5. Do not include any extra commentary or explanation outside the transformed code.
  6. Output only the final code snippet, wrapped in a Markdown code block tagged with "]] .. context.filetype
              end
            },
            {
                role = 'user',
                content = function(context)
                  local text = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
                  return 'Please add types to the following code:\n\n```' .. context.filetype .. '\n' .. text .. "\n```\n\nYou may find the wider context of the file and lsp information helpful in figuring out what types to set #buffer #lsp."
                end,
                opts = {
                  contains_code = true,
                }
            }
          }
        },
        DocString = {
          strategy = 'inline',
          description = 'Comprehensive doc strings to the code',
          opts = {
            modes = { 'v', 'n' },
            short_name = 'doc_string',
          },
          prompts = {
            {
              role = 'system',
              content = function(context)
                local lang = context.filetype
                local doc_types = {
                  typescript = 'tsdoc',
                  typescriptreact = 'tsdoc',
                  javascript = 'jsdoc',
                  javascriptreact = 'jsdoc',
                  python = 'google',
                }

                local doc_type = doc_types[lang] or 'tsdoc'

                return 'You are an expert ' .. context.filetype .. ' developer. Your sole task is to add ' .. doc_type .. ' style documentation to the code that I supply you with. Add ' .. doc_type .. ' decorations to every function, method and class in the code but do not otherwise change anything. Use the surrounding code in the buffer and lsp information in order to improve your descriptions. Aim to be succinct but informative.'
              end
            },
            {
              role = 'user',
              content = function(context)
                local text = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

                return 'I have the following code:\n\n```' .. context.filetype .. '\n' .. text .. "\n```\n\n#buffer #lsp"
              end,
              opts = {
                contains_code = true,
              }
            }
          }
        },
      }
    })

    vim.api.nvim_create_user_command(
      'Ask',
      function(opts)
        vim.cmd('CodeCompanion ' .. opts.args)
      end,
      { nargs = '+' }
    )

    vim.cmd('cnoreabbrev ask Ask')

    vim.api.nvim_create_user_command(
      'Chat',
      function(opts)
        vim.cmd('CodeCompanionChat ' .. opts.args)
      end,
      { nargs = '+' }
    )

    vim.cmd('cnoreabbrev chat Chat')
  end,
}
