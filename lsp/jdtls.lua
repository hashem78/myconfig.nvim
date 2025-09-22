return {
	on_attach = function()
		local bemol_dir = vim.fs.find({ ".bemol" }, { upward = true, type = "directory" })[1]
		local ws_folders_lsp = {}
		if bemol_dir then
			local file = io.open(bemol_dir .. "/ws_root_folders", "r")
			if file then
				for line in file:lines() do
					table.insert(ws_folders_lsp, line)
				end
				file:close()
			end
		end
		local current_folders = vim.lsp.buf.list_workspace_folders()
		for _, line in ipairs(ws_folders_lsp) do
			if not vim.tbl_contains(current_folders, line) then
				vim.lsp.buf.add_workspace_folder(line)
			end
		end
	end,
}
