-- Treesitter: Neovim 0.12 core engine + tree-sitter-manager (parser install +
-- base queries + highlighting) + nvim-treesitter-textobjects (textobjects).
-- The archived nvim-treesitter plugin is intentionally not used.

local PARSERS = {
	"c",
	"lua",
	"python",
	"rust",
	"tsx",
	"javascript",
	"typescript",
	"vimdoc",
	"vim",
	"bash",
	"json",
	"yaml",
	"c_sharp",
	"java",
}

-- Parser manager. highlight defaults to true and it registers FileType
-- autocmds (calling vim.treesitter.start) for installed parsers, so we do NOT
-- add our own highlight autocmd here. Indentation: tree-sitter-manager exposes
-- no indentexpr, so indentation falls back to vim's smartindent (set in
-- mappings.lua) -- treesitter indent was experimental anyway.
require("tree-sitter-manager").setup({
	ensure_installed = PARSERS,
	auto_install = true,
})

-- Incremental selection via core vim.treesitter.select (replaces the old
-- nvim-treesitter incremental_selection module). <c-s> "scope" is dropped --
-- repeat <c-space> to expand instead.
vim.keymap.set({ "n", "x" }, "<c-space>", function()
	vim.treesitter.select("parent")
end, { desc = "TS: init/expand selection to parent node" })
vim.keymap.set("x", "<M-space>", function()
	vim.treesitter.select("child")
end, { desc = "TS: shrink selection to child node" })

-- Textobjects (standalone; bundles its own textobjects.scm queries).
require("nvim-treesitter-textobjects").setup({
	select = { lookahead = true },
	move = { set_jumps = true },
})

local select = require("nvim-treesitter-textobjects.select")
local move = require("nvim-treesitter-textobjects.move")
local swap = require("nvim-treesitter-textobjects.swap")

-- select
local select_maps = {
	aa = "@parameter.outer",
	ia = "@parameter.inner",
	af = "@function.outer",
	["if"] = "@function.inner",
	ac = "@class.outer",
	ic = "@class.inner",
}
for lhs, capture in pairs(select_maps) do
	vim.keymap.set({ "x", "o" }, lhs, function()
		select.select_textobject(capture, "textobjects")
	end, { desc = "TS select " .. capture })
end

-- move
local function nmap(lhs, fn, capture, desc)
	vim.keymap.set({ "n", "x", "o" }, lhs, function()
		fn(capture, "textobjects")
	end, { desc = desc })
end
nmap("]m", move.goto_next_start, "@function.outer", "Next function start")
nmap("]]", move.goto_next_start, "@class.outer", "Next class start")
nmap("]M", move.goto_next_end, "@function.outer", "Next function end")
nmap("][", move.goto_next_end, "@class.outer", "Next class end")
nmap("[m", move.goto_previous_start, "@function.outer", "Prev function start")
nmap("[[", move.goto_previous_start, "@class.outer", "Prev class start")
nmap("[M", move.goto_previous_end, "@function.outer", "Prev function end")
nmap("[]", move.goto_previous_end, "@class.outer", "Prev class end")

-- swap
vim.keymap.set("n", "<leader>a", function()
	swap.swap_next("@parameter.inner")
end, { desc = "TS swap next parameter" })
vim.keymap.set("n", "<leader>A", function()
	swap.swap_previous("@parameter.inner")
end, { desc = "TS swap previous parameter" })
