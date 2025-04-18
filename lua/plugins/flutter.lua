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
		settings = {
			renameFilesWithClasses = "always",
		},
		fvm = true, -- takes priority over path, uses <workspace>/.fvm/flutter_sdk if enabled
		dev_log = {
			filter = function(log_line)
				local patterns_to_ignore = {
					"^D/EGL_emulation",
					"^D/InsetsController",
					"^D/InputMethodManager",
					"^E/libEGL",
					"^W/StorageUtil",
				}

				for _, pattern in ipairs(patterns_to_ignore) do
					if log_line:match(pattern) then
						return false
					end
				end

				return true
			end,
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
