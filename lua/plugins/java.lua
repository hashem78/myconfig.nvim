return {
	'nvim-java/nvim-java',
	config = function()
		require('java').setup()
		require('lspconfig').jdtls.setup {
			on_attach = require('shared').on_lsp_attach,
		}
	end,
	dependencies = {
		'nvim-java/lua-async-await',
		'nvim-java/nvim-java-core',
		'nvim-java/nvim-java-test',
		'nvim-java/nvim-java-dap',
		'nvim-java/nvim-java-refactor',
		'MunifTanjim/nui.nvim',
		'neovim/nvim-lspconfig',
		'mfussenegger/nvim-dap',
		{
			'williamboman/mason.nvim',
			opts = {
				registries = {
					'github:nvim-java/mason-registry',
					'github:mason-org/mason-registry',
				},
			},
		},
	},
}
