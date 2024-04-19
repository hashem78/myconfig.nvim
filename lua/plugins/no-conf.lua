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
}
