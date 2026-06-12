local fzfLua = require("fzf-lua")

-- Custom picker: parse a Brazil packageInfo and open a package dir in oil.
local function parse_package_info()
	local workspace_root = vim.fn.getcwd()
	local package_info_path = workspace_root .. "/packageInfo"

	if vim.fn.filereadable(package_info_path) == 0 then
		vim.notify("packageInfo file not found in workspace root", vim.log.levels.ERROR)
		return nil
	end

	local file = io.open(package_info_path, "r")
	if not file then
		vim.notify("Could not read packageInfo file", vim.log.levels.ERROR)
		return nil
	end

	local content = file:read("*all")
	file:close()

	local packages = {}
	local in_packages_block = false

	for line in content:gmatch("[^\r\n]+") do
		line = line:gsub("^%s+", ""):gsub("%s+$", "")

		if line:match("^packages%s*=%s*{") then
			in_packages_block = true
		elseif line:match("^}") and in_packages_block then
			in_packages_block = false
		elseif in_packages_block then
			local package_name = line:match("([%w_]+)%-%d+%.%d+%s*=%s*%.;")
			if package_name then
				table.insert(packages, package_name)
			end
		end
	end

	return packages, workspace_root
end

local function open_package_picker()
	local packages, workspace_root = parse_package_info()

	if not packages or #packages == 0 then
		vim.notify("No packages found in packageInfo", vim.log.levels.WARN)
		return
	end

	fzfLua.fzf_exec(packages, {
		prompt = "Select Package > ",
		winopts = {
			height = 0.4,
			width = 0.6,
			title = " 📦 Package Selector ",
			title_pos = "center",
		},
		actions = {
			["default"] = function(selected)
				if selected and #selected > 0 then
					local package_name = selected[1]
					local package_path = workspace_root .. "/src/" .. package_name
					if vim.fn.isdirectory(package_path) == 1 then
						require("oil").open(package_path)
					else
						vim.notify("Package directory not found: " .. package_path, vim.log.levels.ERROR)
					end
				end
			end,
			["ctrl-s"] = function(selected)
				if selected and #selected > 0 then
					local package_name = selected[1]
					local package_path = workspace_root .. "/src/" .. package_name
					vim.cmd("split")
					require("oil").open(package_path)
				end
			end,
			["ctrl-v"] = function(selected)
				if selected and #selected > 0 then
					local package_name = selected[1]
					local package_path = workspace_root .. "/src/" .. package_name
					vim.cmd("vsplit")
					require("oil").open(package_path)
				end
			end,
		},
	})
end

fzfLua.setup({
	files = {
		path_shorten = true,
	},
})

vim.keymap.set("n", "<leader>?", fzfLua.oldfiles, { desc = "[?] Find recently opened files" })
vim.keymap.set("n", "<leader><space>", fzfLua.buffers, { desc = "[ ] Find existing buffers" })

vim.keymap.set("n", "<leader>ss", fzfLua.builtin, { desc = "[S]earch [S]elect Telescope" })
vim.keymap.set("n", "<leader>gf", fzfLua.git_files, { desc = "Search [G]it [F]iles" })
vim.keymap.set("n", "<leader>sf", fzfLua.files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sh", fzfLua.helptags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sw", fzfLua.grep_cword, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sg", fzfLua.live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sr", fzfLua.resume, { desc = "[S]earch [R]esume" })
vim.keymap.set("n", "<leader>qf", fzfLua.quickfix, { desc = "[S]earch [R]esume" })

vim.keymap.set("n", "<leader>tb", fzfLua.tmux_buffers, { desc = "List [T]mux [B]uffers" })

vim.keymap.set("n", "<leader>pp", open_package_picker, { desc = "Pick Package" })
