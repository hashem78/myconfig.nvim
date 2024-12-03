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
	}
}
