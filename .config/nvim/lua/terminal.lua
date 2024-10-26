-- Configuration for better terminal handling
local api = vim.api
local cmd = vim.cmd
local fn = vim.fn

-- Create a terminal buffer manager
local M = {}
M.term_buf = nil
M.term_win = nil
M.command_history = {}
M.current_command = nil

-- Function to check if we're running in Neovim terminal
function M.is_neovim_terminal()
    return vim.env.NVIM ~= nil
end

-- Function to create a new terminal buffer
function M.create_terminal()
    -- Create new terminal buffer
    cmd('botright 15split')
    local win = api.nvim_get_current_win()
    local buf = api.nvim_create_buf(false, true)
    
    -- Set buffer options before creating terminal
    api.nvim_buf_set_option(buf, 'buflisted', false)
    api.nvim_buf_set_option(buf, 'modifiable', true)
    api.nvim_win_set_buf(win, buf)
    
    -- Determine shell command based on environment
    local shell_cmd
    if M.is_neovim_terminal() then
        -- If we're in Neovim, use shell directly without tmux
        shell_cmd = vim.o.shell
    else
        -- Normal terminal initialization
        shell_cmd = vim.o.shell
    end
    
    -- Create terminal with appropriate shell
    cmd('terminal ' .. shell_cmd)
    
    -- Set terminal specific options
    api.nvim_buf_set_option(buf, 'bufhidden', 'hide')
    api.nvim_win_set_option(win, 'number', false)
    api.nvim_win_set_option(win, 'relativenumber', false)
    
    -- Store buffer and window handles
    M.term_buf = buf
    M.term_win = win
    
    -- Enter terminal mode automatically
    cmd('startinsert')
    
    return buf, win
end

-- Function to toggle terminal window
function M.toggle_terminal()
    if not M.term_buf or not api.nvim_buf_is_valid(M.term_buf) then
        M.create_terminal()
        return
    end

    local wins = api.nvim_list_wins()
    local term_win_open = false
    for _, win in ipairs(wins) do
        if api.nvim_win_get_buf(win) == M.term_buf then
            api.nvim_win_close(win, true)
            term_win_open = true
            M.term_win = nil
            break
        end
    end

    if not term_win_open then
        cmd('botright 15split')
        M.term_win = api.nvim_get_current_win()
        api.nvim_win_set_buf(M.term_win, M.term_buf)
        cmd('startinsert')
    end
end

-- Function to capture command output
function M.capture_command(command)
    -- Remove leading '!' if present
    command = command:gsub('^!', '')
    
    -- Store command in history
    table.insert(M.command_history, command)
    M.current_command = #M.command_history
    
    -- Create or show terminal
    if not M.term_buf or not api.nvim_buf_is_valid(M.term_buf) then
        local buf, _ = M.create_terminal()
        M.term_buf = buf
    else
        M.toggle_terminal()
    end
    
    -- Get terminal job ID
    local success, job_id = pcall(api.nvim_buf_get_var, M.term_buf, 'terminal_job_id')
    if success then
        -- Clear terminal and send command
        api.nvim_chan_send(job_id, "clear && " .. command .. " && echo '\\nPress any key to close...' && read -n 1\n")
    end
end

-- Function to show last command output
function M.show_last_output()
    if #M.command_history > 0 then
        M.capture_command(M.command_history[M.current_command])
    else
        print("No previous command output to show")
    end
end

-- Function to cycle through command history
function M.cycle_history(direction)
    if #M.command_history == 0 then
        print("No command history available")
        return
    end
    
    if direction == "prev" then
        M.current_command = math.max(1, (M.current_command or #M.command_history) - 1)
    else
        M.current_command = math.min(#M.command_history, (M.current_command or 1) + 1)
    end
    
    M.capture_command(M.command_history[M.current_command])
end

-- Set up key mappings
vim.keymap.set('n', '<Leader>t', function() M.toggle_terminal() end, { noremap = true, silent = true })
vim.keymap.set('t', '<C-\\><C-n>', '<C-\\><C-n>', { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>l', function() M.show_last_output() end, { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>[', function() M.cycle_history("prev") end, { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>]', function() M.cycle_history("next") end, { noremap = true, silent = true })

-- Override bang command behavior
cmd([[
  function! BangCommand(cmd)
    lua require('terminal').capture_command(vim.fn.expand('<q-args>'))
  endfunction
  
  command! -nargs=+ -complete=file_in_path Bang call BangCommand(<q-args>)
  cnoreabbrev <expr> ! getcmdtype() == ':' && getcmdline() =~ '^!' ? 'Bang' : '!'
]])

-- Set up autocommands for terminal behavior
cmd([[
  augroup CustomTerminal
    autocmd!
    autocmd TermOpen * setlocal nonumber norelativenumber signcolumn=no
    autocmd TermEnter * startinsert
    autocmd TermClose * if !v:event.status | exe 'bdelete! '..expand('<abuf>') | endif
  augroup END
]])

return M
