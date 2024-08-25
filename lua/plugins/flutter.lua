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

	nmap('gd', fzfLua.lsp_definitions, '[G]oto [D]efinition')
	nmap('gr', fzfLua.lsp_references, '[G]oto [R]eferences')
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


	vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
		vim.lsp.buf.format()
	end, { desc = 'Format current buffer with LSP' })
end
return {
	'akinsho/flutter-tools.nvim',
	config = function(_, opts)
		require("flutter-tools").setup(opts)
		-- require("telescope").load_extension("flutter")
	end,
	opts = {
		lsp = {
			color = {
				enabled = true,
			},
			on_attach = on_attach,
			settings = {
				analysisExcludedFolders = {
					vim.fn.expand('$HOME/.pub-cache'),
				},
				lineLength = 120,
			},
		},
	},
	-- lazy = false,
	dependencies = {
		-- 'nvim-telescope/telescope.nvim',
		'nvim-lua/plenary.nvim',
		'stevearc/dressing.nvim', -- optional for vim.ui.select
		'RobertBrunhage/flutter-riverpod-snippets',
	},

}
