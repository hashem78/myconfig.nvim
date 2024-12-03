return {
	"nvim-lualine/lualine.nvim",
	opts = {
		options = {
			icons_enabled = false,
			theme = 'catppuccin',
			component_separators = '|',
			section_separators = '',
		},
	},
	config = function(_, opts)
		require('lualine').setup(opts)
		if os.getenv('TMUX') then
			vim.defer_fn(function() vim.o.laststatus = 0 end, 0)
		end
	end
}
