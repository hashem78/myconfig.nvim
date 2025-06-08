M = {}
function M.on_lsp_attach(_, bufnr)
	local nmap = function(keys, func, desc)
		if desc then
			desc = 'LSP: ' .. desc
		end

		vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
	end

	local fzfLua = require("fzf-lua")
	nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
	nmap('<leader>ca', fzfLua.lsp_code_actions, '[C]ode [A]ction')

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

	nmap('<leader>th', function()
		vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr })
	end, '[T]oggle Inlay [H]ints')
end

return M
