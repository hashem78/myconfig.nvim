return {
	'nvim-java/nvim-java',
	config = false,
	dependencies = {
		{
			'neovim/nvim-lspconfig',
			opts = {
				setup = {
					jdtls = function()
						require('java').setup({
							-- Your custom nvim-java configuration goes here
						})
					end,
				},
			},
		},
		'nvim-java/lua-async-await',
		'nvim-java/nvim-java-core',
		'nvim-java/nvim-java-test',
		'nvim-java/nvim-java-dap',
		'nvim-java/nvim-java-refactor',
		'MunifTanjim/nui.nvim',
		'mfussenegger/nvim-dap',
		{
			'williamboman/mason.nvim',
			opts = {
				registries = {
					'github:nvim-java/mason-registry',
					'github:mason-org/mason-registry',
				},
			},
		}
	},
}
