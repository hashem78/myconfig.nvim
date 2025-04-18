return {
	'tpope/vim-fugitive',
	'tpope/vim-rhubarb',
	'tpope/vim-sleuth',
	{
		'numToStr/Comment.nvim',
		config = function()
			require('Comment').setup()
		end
	},
	'p00f/clangd_extensions.nvim',
	-- 'vimpostor/vim-tpipeline',
	{
		'echasnovski/mini.move',
		config = function()
			require('mini.move').setup()
		end
	},
	{
		"mbbill/undotree",
		lazy = false,
		config = function()
			vim.keymap.set('n', '<leader><F5>', vim.cmd.UndotreeToggle)
		end
	},
	{
		'echasnovski/mini.statusline',
		config = function()
			require('mini.statusline').setup()
		end,
		version = '*',
	},
	{
		"lervag/vimtex",
		lazy = false, -- we don't want to lazy load VimTeX
		-- tag = "v2.15", -- uncomment to pin to a specific release
		init = function()
			-- VimTeX configuration goes here, e.g.
			vim.g.vimtex_view_method = "zathura"
			vim.g.vimtex_compiler_latexmk = {
				options = {
					'-verbose',
					'-file-line-error',
					'-synctex=1',
					'-interaction=nonstopmode',
					'-shell-escape',
				},
			}
		end
	}
}
