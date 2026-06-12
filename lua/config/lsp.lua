-- LSP wiring: mason (mason-org repos) + nvim-lspconfig base configs +
-- vim.lsp.config/enable. Server-specific settings live in lsp/<name>.lua.

-- Filter out noisy diagnostics from generated/bemol paths.
local orig_handler = vim.lsp.handlers["textDocument/publishDiagnostics"]
vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
	local uri = (result and result.uri) or ""
	if uri:find("%.bemol/") or uri:find("/generated%-sources/") then
		return
	end
	return orig_handler(err, result, ctx, config)
end

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
	callback = function(event)
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if client == nil then
			return
		end
		if client.name == "ruff" then
			-- Use ruff for linting/formatting only; let pyright own hover.
			---@diagnostic disable-next-line: inject-field
			client.server_capabilities.hoverProvider = false
		end

		require("shared").on_lsp_attach(client, event.buf)

		-- jdtls: load bemol workspace roots so cross-package nav works.
		if client.name == "jdtls" then
			local bemol_dir = vim.fs.find({ ".bemol" }, { upward = true, type = "directory" })[1]
			if bemol_dir then
				local file = io.open(bemol_dir .. "/ws_root_folders", "r")
				if file then
					local existing = vim.lsp.buf.list_workspace_folders()
					for line in file:lines() do
						if not vim.tbl_contains(existing, line) then
							vim.lsp.buf.add_workspace_folder(line)
						end
					end
					file:close()
				end
			end
		end
	end,
})

-- Capabilities from blink + folding range (for nvim-ufo).
local capabilities = require("blink.cmp").get_lsp_capabilities()
capabilities.textDocument.foldingRange = {
	dynamicRegistration = false,
	lineFoldingOnly = true,
}
vim.lsp.config("*", { capabilities = capabilities })

local servers = { "lua_ls", "pyright", "ruff", "ts_ls" }
-- jdtls is intentionally NOT enabled here; nvim-jdtls owns its lifecycle via
-- start_or_attach (enabling it too would double-attach).

for _, server_name in ipairs(servers) do
	vim.lsp.enable(server_name)
end

-- mason: must set up mason first, then mason-lspconfig (with nvim-lspconfig on
-- rtp), then the tool installer.
require("mason").setup()
require("mason-lspconfig").setup({
	automatic_enable = false, -- we call vim.lsp.enable ourselves above
	ensure_installed = {},
})
require("mason-tool-installer").setup({
	ensure_installed = vim.list_extend(
		vim.deepcopy(servers),
		{ "jdtls", "stylua", "prettier", "black", "isort" }
	),
})
