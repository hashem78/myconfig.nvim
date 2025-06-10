return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "williamboman/mason.nvim", config = true },
		"williamboman/mason-lspconfig.nvim",
		{ "j-hui/fidget.nvim", opts = {} },
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"saghen/blink.cmp",
	},
	config = function()
		local shared = require("shared")
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
			callback = function(event)
				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if client == nil then
					return
				end
				if client.name == "ruff" then
					---@diagnostic disable-next-line: inject-field
					client.server_capabilities.hoverrovider = false
				end
				shared.on_lsp_attach(client, event.buf)
			end,
		})

		local capabilities = require("blink.cmp").get_lsp_capabilities()
		capabilities.textDocument.foldingRange = {
			dynamicRegistration = false,
			lineFoldingOnly = true,
		}

		vim.lsp.config("*", { capabilities = capabilities })
		local servers = {
			"gopls",
			"lua_ls",
			"clangd",
			"pyright",
			"ruff",
			"jdtls",
			"ts_ls",
		}
		local to_be_installed = vim.list_extend(servers, { "stylua", "prettier" })

		for _, server_name in ipairs(servers) do
			if server_name == "jdtls" then
				goto continue
			end
			vim.lsp.enable(server_name)
			::continue::
		end

		require("mason-tool-installer").setup({ ensure_installed = to_be_installed })

		require("mason-lspconfig").setup({
			automatic_enable = false,
			ensure_installed = {},
			automatic_installation = true,
		})
	end,
}
