return {
	'akinsho/flutter-tools.nvim',
	config = function(_, opts)
		require("flutter-tools").setup(opts)
		-- require("telescope").load_extension("flutter")
	end,
	opts = {
		lsp = {
			color = {
				enabled = true,
			},
			on_attach = require('shared').on_lsp_attach,
			settings = {
				analysisExcludedFolders = {
					vim.fn.expand('$HOME/.pub-cache'),
				},
				lineLength = 120,
			},
		},
	},
	-- lazy = false,
	dependencies = {
		-- 'nvim-telescope/telescope.nvim',
		'nvim-lua/plenary.nvim',
		'stevearc/dressing.nvim', -- optional for vim.ui.select
		'RobertBrunhage/flutter-riverpod-snippets',
	},

}
