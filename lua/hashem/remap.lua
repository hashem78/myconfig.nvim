vim.o.tabstop = 2
vim.o.shiftwidth = 2

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = 'Move line up' })
-- vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = 'Move line down' })
-- vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = 'Move line up' })
-- vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = 'Move line down' })
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = 'Move line up' })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = 'Move line down' })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=1<CR>gv", { desc = 'Move line up' })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=1<CR>gv", { desc = 'Move line down' })
