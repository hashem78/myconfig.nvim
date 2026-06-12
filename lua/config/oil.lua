-- File explorer (oil.nvim). The `-` keymap to open the parent dir lives in
-- mappings.lua.
local opts = {
	default_file_explorer = true,
	columns = {
		"icon",
	},
	buf_options = {
		buflisted = false,
		bufhidden = "hide",
	},
	win_options = {
		wrap = false,
		signcolumn = "no",
		cursorcolumn = false,
		foldcolumn = "0",
		spell = false,
		list = false,
		conceallevel = 3,
		concealcursor = "nvic",
	},
	delete_to_trash = false,
	skip_confirm_for_simple_edits = false,
	prompt_save_on_select_new_entry = true,
	cleanup_delay_ms = 2000,
	lsp_file_methods = {
		timeout_ms = 1000,
		autosave_changes = false,
	},
	constrain_cursor = "editable",
	watch_for_changes = true,
	keymaps = {
		["g?"] = "actions.show_help",
		["<CR>"] = "actions.select",
		["<C-s>"] = { "actions.select", opts = { vertical = true }, desc = "Open the entry in a vertical split" },
		["<C-h>"] = {
			"actions.select",
			opts = { horizontal = true },
			desc = "Open the entry in a horizontal split",
		},
		["<C-t>"] = { "actions.select", opts = { tab = true }, desc = "Open the entry in new tab" },
		["<C-p>"] = "actions.preview",
		["<C-c>"] = "actions.close",
		["<C-l>"] = "actions.refresh",
		["-"] = "actions.parent",
		["_"] = "actions.open_cwd",
		["`"] = "actions.cd",
		["~"] = { "actions.cd", opts = { scope = "tab" }, desc = ":tcd to the current oil directory" },
		["gs"] = "actions.change_sort",
		["gx"] = "actions.open_external",
		["g."] = "actions.toggle_hidden",
		["g\\"] = "actions.toggle_trash",
		["yp"] = {
			desc = "Copy filepath to system clipboard",
			callback = function()
				require("oil.actions").copy_entry_path.callback()
				vim.fn.setreg("+", vim.fn.getreg(vim.v.register))
			end,
		},
	},
	use_default_keymaps = true,
	view_options = {
		show_hidden = false,
		is_hidden_file = function(name, bufnr)
			return vim.startswith(name, ".")
		end,
		is_always_hidden = function(name, bufnr)
			return false
		end,
		natural_order = true,
		sort = {
			{ "type", "asc" },
			{ "name", "asc" },
		},
	},
	extra_scp_args = {},
	git = {
		add = function(path)
			return false
		end,
		mv = function(src_path, dest_path)
			return false
		end,
		rm = function(path)
			return false
		end,
	},
	float = {
		padding = 2,
		max_width = 0,
		max_height = 0,
		border = "rounded",
		win_options = {
			winblend = 0,
		},
		preview_split = "auto",
		override = function(conf)
			return conf
		end,
	},
	-- Renamed from `preview` -> `preview_win` (the old top-level `preview` key
	-- is silently ignored in current oil).
	preview_win = {
		max_width = 0.9,
		min_width = { 40, 0.4 },
		width = nil,
		max_height = 0.9,
		min_height = { 5, 0.1 },
		height = nil,
		border = "rounded",
		win_options = {
			winblend = 0,
		},
		update_on_cursor_moved = true,
	},
	progress = {
		max_width = 0.9,
		min_width = { 40, 0.4 },
		width = nil,
		max_height = { 10, 0.9 },
		min_height = { 5, 0.1 },
		height = nil,
		border = "rounded",
		minimized_border = "none",
		win_options = {
			winblend = 0,
		},
	},
	ssh = {
		border = "rounded",
	},
	keymaps_help = {
		border = "rounded",
	},
}

-- Hide gitignored/untracked-dotfiles in oil, with a per-dir git status cache.
local function parse_output(proc)
	local result = proc:wait()
	local ret = {}
	if result.code == 0 then
		for line in vim.gsplit(result.stdout, "\n", { plain = true, trimempty = true }) do
			line = line:gsub("/$", "")
			ret[line] = true
		end
	end
	return ret
end

local function new_git_status()
	return setmetatable({}, {
		__index = function(self, key)
			local ignore_proc = vim.system(
				{ "git", "ls-files", "--ignored", "--exclude-standard", "--others", "--directory" },
				{
					cwd = key,
					text = true,
				}
			)
			local tracked_proc = vim.system({ "git", "ls-tree", "HEAD", "--name-only" }, {
				cwd = key,
				text = true,
			})
			local ret = {
				ignored = parse_output(ignore_proc),
				tracked = parse_output(tracked_proc),
			}

			rawset(self, key, ret)
			return ret
		end,
	})
end
local git_status = new_git_status()

-- Clear git status cache on refresh
local refresh = require("oil.actions").refresh
local orig_refresh = refresh.callback
refresh.callback = function(...)
	git_status = new_git_status()
	orig_refresh(...)
end

opts.view_options = {
	is_hidden_file = function(name, bufnr)
		local dir = require("oil").get_current_dir(bufnr)
		local is_dotfile = vim.startswith(name, ".") and name ~= ".."
		if not dir then
			return is_dotfile
		end
		if is_dotfile then
			return not git_status[dir].tracked[name]
		else
			return git_status[dir].ignored[name]
		end
	end,
}
require("oil").setup(opts)
