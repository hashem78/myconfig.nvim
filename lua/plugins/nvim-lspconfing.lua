local on_attach = function(client, bufnr)
	local nmap = function(keys, func, desc)
		if desc then
			desc = 'LSP: ' .. desc
		end

		vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
	end

	local fzfLua = require("fzf-lua")
	nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
	nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

	nmap('gr', fzfLua.lsp_references, '[G]oto [R]eferences')
	nmap('gd', fzfLua.lsp_definitions, '[G]oto [D]efinition')
	nmap('gI', fzfLua.lsp_implementations, '[G]oto [I]mplementation')
	nmap('<leader>sd', fzfLua.diagnostics_workspace, '[S]earch [D]iagnostics')
	nmap('<leader>sD', fzfLua.diagnostics_document, '[S]earch [D]iagnostics Document')
	nmap('<leader>D', fzfLua.lsp_definitions, 'Type [D]efinition')

	nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
	nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

	nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
	nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
	nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
	nmap('<leader>wl', function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, '[W]orkspace [L]ist Folders')
end

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
			jdtls = {},
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
		}

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
		capabilities.textDocument.foldingRange = {
			dynamicRegistration = false,
			lineFoldingOnly = true,
		}

		mason_lspconfig.setup {
			ensure_installed = vim.tbl_keys(servers),
		}

		mason_lspconfig.setup_handlers {
			function(server_name)
				local custom_on_attach = on_attach
				if server_name == 'clangd' then
					custom_on_attach = function(client, bufnr)
						on_attach(client, bufnr)
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
						on_attach(client, bufnr)
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
