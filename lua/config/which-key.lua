local wk = require("which-key")

-- Group labels for leader prefixes. Individual mappings document themselves via
-- their `desc` at the vim.keymap.set call site; these just name the groups.
wk.add({
	{ "<leader>c", group = "[C]ode" }, -- ca: code action
	{ "<leader>f", group = "[F]ormat" }, -- f: buffer, fj/fcj: jq json
	{ "<leader>g", group = "[G]it" }, -- gf: git files
	{ "<leader>h", group = "Git [H]unk" }, -- stage/reset/preview/blame/diff
	{ "<leader>r", group = "[R]ename" }, -- rn: lsp rename
	{ "<leader>s", group = "[S]earch" }, -- fzf-lua pickers + diagnostics
	{ "<leader>t", group = "[T]oggle" }, -- th: inlay hints, tb: tmux bufs, td: deleted hunk
	{ "<leader>w", group = "[W]orkspace" }, -- lsp workspace folders
	{ "<leader>x", group = "Trouble / Diagnostics" }, -- xx/xw/xd/xq/xl
	{ "<leader>p", group = "[P]ackage" }, -- pp: brazil package picker
})

-- Visual-mode groups.
wk.add({
	{ "<leader>h", group = "Git [H]unk", mode = "v" }, -- stage/reset hunk on selection
	{ "<leader>f", group = "[F]ormat", mode = "v" }, -- fj/fcj: jq on selection
})
