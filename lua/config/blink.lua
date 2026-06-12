-- Completion: blink.cmp + LuaSnip + friendly-snippets.
-- blink downloads its prebuilt fuzzy binary at runtime; no build step needed.

require("luasnip.loaders.from_vscode").lazy_load()

--- @module 'blink.cmp'
--- @type blink.cmp.Config
local opts = {
	keymap = {
		preset = "enter",
		["<Tab>"] = { "show_and_insert", "select_next" },
		["<S-Tab>"] = { "show_and_insert", "select_prev" },
	},

	appearance = {
		-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
		nerd_font_variant = "mono",
	},

	completion = {
		documentation = { auto_show = false, auto_show_delay_ms = 500 },
	},

	sources = {
		default = { "lsp", "path", "snippets", "lazydev" },
		providers = {
			lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
		},
	},

	snippets = { preset = "luasnip" },

	fuzzy = { implementation = "prefer_rust_with_warning" },

	signature = { enabled = true },
}

require("blink.cmp").setup(opts)
