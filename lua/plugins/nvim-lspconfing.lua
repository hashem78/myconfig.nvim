return {
	'neovim/nvim-lspconfig',
	dependencies = {
		{ 'williamboman/mason.nvim', config = true },
		'williamboman/mason-lspconfig.nvim',
		{ 'j-hui/fidget.nvim',       opts = {} },
		'folke/neodev.nvim',
	},
	config = function()
		require('mason').setup()
		require('mason-lspconfig').setup()
		require('neodev').setup()

		local mason_lspconfig = require('mason-lspconfig')
		local servers = {
			clangd = {},
			pyright = {
				pyright = {
					-- Using Ruff's import organizer
					disableOrganizeImports = true,
				},
				python = {
					analysis = {
						-- Ignore all files for analysis to exclusively use Ruff for linting
						ignore = { '*' },
					},
				},
			},
			bashls = {},
			yamlls = {},
			ruff = {
				init_options = {
					settings = {
						path = { vim.fn.exepath('ruff') },
					},
				},
			},
			lua_ls = {
				Lua = {
					workspace = { checkThirdParty = false },
					telemetry = { enable = false },
				},
			},
			csharp_ls = { },
		}

		local shared = require('shared')

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
		capabilities.textDocument.foldingRange = {
			dynamicRegistration = false,
			lineFoldingOnly = true,
		}

		mason_lspconfig.setup {
			ensure_installed = vim.tbl_keys(servers),
		}

		require('lspconfig').beancount.setup({
			capabilities = capabilities,
			on_attach = shared.on_lsp_attach,
			cmd = { vim.fn.expand('$HOME/.cargo/bin/beancount-language-server') }
		})


		mason_lspconfig.setup_handlers {
			function(server_name)
				local custom_on_attach = shared.on_lsp_attach
				if server_name == 'clangd' then
					custom_on_attach = function(client, bufnr)
						shared.on_lsp_attach(client, bufnr)
						local nmap = function(keys, func, desc)
							if desc then
								desc = 'LSP: ' .. desc
							end

							vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
						end
						require("clangd_extensions.inlay_hints").setup_autocmd()
						require("clangd_extensions.inlay_hints").set_inlay_hints()
						nmap('<leader>gsh', ':ClangdSwitchSourceHeader<CCRR>', '[G]o to source/header')
					end
				end
				if server_name == 'ruff' then
					custom_on_attach = function(client, bufnr)
						shared.on_lsp_attach(client, bufnr)
						client.server_capabilities.hoverProvider = false
					end
				end
				require('lspconfig')[server_name].setup {
					capabilities = capabilities,
					on_attach = custom_on_attach,
					settings = servers[server_name],
					filetypes = (servers[server_name] or {}).filetypes,
				}
			end,
		}
	end
}
