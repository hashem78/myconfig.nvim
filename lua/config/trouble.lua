-- Diagnostics/quickfix/LSP list (trouble.nvim v3).
require("trouble").setup({
	indent_guides = false,
	icons = {
		indent = {
			fold_open = "v ",
			fold_closed = "> ",
		},
	},
})

-- v3 uses mode names + the :Trouble command; the old v2 string modes
-- (workspace_diagnostics/document_diagnostics) no longer exist.
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics" })
vim.keymap.set("n", "<leader>xw", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Workspace diagnostics" })
vim.keymap.set(
	"n",
	"<leader>xd",
	"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
	{ desc = "Document diagnostics" }
)
vim.keymap.set("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix" })
vim.keymap.set("n", "<leader>xl", "<cmd>Trouble loclist toggle<cr>", { desc = "Location list" })
vim.keymap.set("n", "gR", "<cmd>Trouble lsp_references toggle<cr>", { desc = "References" })
