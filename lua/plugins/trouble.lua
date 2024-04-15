return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		vim.keymap.set("n", "<leader>xx", function() require("trouble").toggle() end, { desc = "Open diagnostics" })
		vim.keymap.set("n", "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end,
			{ desc = "Show workspace diagnostics" })
		vim.keymap.set("n", "<leader>xd", function() require("trouble").toggle("document_diagnostics") end,
			{ desc = "Show document diagnostics" })
		vim.keymap.set("n", "<leader>xq", function() require("trouble").toggle("quickfix") end,
			{ desc = "Show quickfixes" })
		vim.keymap.set("n", "<leader>xl", function() require("trouble").toggle("loclist") end,
			{ desc = "Show location list" })
		vim.keymap.set("n", "gR", function() require("trouble").toggle("lsp_references") end,
			{ desc = "Show references" })
	end,
	opts = {
		icons = false,
		fold_open = "v", -- icon used for open folds
		fold_closed = ">", -- icon used for closed folds
		indent_lines = false, -- add an indent guide below the fold icons
		signs = {
			-- icons / text used for a diagnostic
			error = "error",
			warning = "warn",
			hint = "hint",
			information = "info"
		},
		use_diagnostic_signs = false -- enabling this will use the signs defined in your lsp client
	},
}
