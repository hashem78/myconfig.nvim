-- Lua dev: types/completion for vim.uv etc. (loaded eagerly under vim.pack).
require("lazydev").setup({
	library = {
		-- Load luvit types when the `vim.uv` word is found.
		{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
	},
})
