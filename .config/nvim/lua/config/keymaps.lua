-- Set leader key to comma
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- Helper function for better mapping experience
local function opts(desc)
    return { noremap = true, silent = true, desc = desc }
end

-- Make Y behave like other capitals
vim.keymap.set("n", "Y", "y$", opts("Yank to end of line"))

-- reselect visual block after indenting
vim.keymap.set("v", ">", ">gv", opts("Indent and reselect"))
vim.keymap.set("v", "<", "<gv", opts("Outdent and reselect"))

-- Enter/Shift+Enter to insert blank lines without entering insert mode
vim.keymap.set("n", "<CR>", "o<ESC>", opts("Insert line below"))
vim.keymap.set("n", "<S-CR>", "O<ESC>", opts("Insert line above"))

-- Tab/pane management
vim.keymap.set("n", "\\", ":vsp<CR>", opts("Split vertically"))
vim.keymap.set("n", "-", ":sp<CR>", opts("Split horizontally"))
vim.keymap.set("n", "<C-t>", ":tabnew<CR>", opts("New tab"))
vim.keymap.set("n", "<C-n>", ":tabnext<CR>", opts("Next tab"))
vim.keymap.set("n", "<C-p>", ":tabprevious<CR>", opts("Previous tab"))

-- Clear search highlights
vim.keymap.set("n", "<Leader>/", ":let @/=\"\"<CR>", opts("Clear search highlights"))

-- Toggle relative line numbers
vim.keymap.set("n", "<Leader>n", function()
    vim.wo.relativenumber = not vim.wo.relativenumber
end, opts("Toggle relative line numbers"))

-- Toggle tab mode (2 spaces vs 4 tabs)
vim.keymap.set("n", "<Leader>q", function()
    if vim.bo.softtabstop == 2 then
        vim.bo.softtabstop = 4
        vim.bo.shiftwidth = 4
        vim.bo.expandtab = false
        print("Switched to tabs (width 4)")
    else
        vim.bo.softtabstop = 2
        vim.bo.shiftwidth = 2
        vim.bo.expandtab = true
        print("Switched to spaces (width 2)")
    end
end, opts("Toggle tab mode"))

-- Disable unwanted mappings
vim.keymap.set("n", "<F1>", "<nop>", opts("Disable F1"))
vim.keymap.set("n", "K", "<nop>", opts("Disable K"))

-- easier testing

-- Helper function to run tests based on project type
local function run_project_tests(current_file)
    local test_cmd = ""
    if vim.fn.filereadable("Makefile") == 1 then
        test_cmd = "make test"
    elseif vim.fn.filereadable("Rakefile") == 1 then
        test_cmd = "rake test"
    elseif vim.fn.filereadable("Gruntfile.js") == 1 then
        test_cmd = "grunt test"
    elseif vim.fn.filereadable("Gulpfile.js") == 1 then
        test_cmd = "gulp test"
    elseif vim.fn.filereadable("package.json") == 1 then
        test_cmd = "npm run test --silent"
        if current_file then
            test_cmd = test_cmd .. " -- " .. current_file
        end
    end

    if test_cmd ~= "" then
        vim.cmd("T " .. test_cmd)
    end
end

-- Run all tests
vim.keymap.set("n", "<Leader>t", function()
    run_project_tests()
end, { noremap = true })

-- Run tests for current file
vim.keymap.set("n", "<Leader>T", function()
    run_project_tests(vim.fn.expand("%"))
end, { noremap = true })
