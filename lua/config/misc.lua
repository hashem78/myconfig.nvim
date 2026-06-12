-- Misc plugins. Vimscript ones (fugitive, rhubarb, sleuth, tmux-navigator,
-- undotree) are sourced via load=true in pack.lua; here we configure the Lua
-- ones and set undotree's keymap.

require("Comment").setup()

require("mini.move").setup({
	mappings = { down = "J", up = "K" },
})

require("mini.statusline").setup()

vim.keymap.set("n", "<leader><F5>", vim.cmd.UndotreeToggle, { desc = "Toggle undotree" })
