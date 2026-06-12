-- Native plugin management via vim.pack (Neovim 0.12+).
-- Plugins install to stdpath('data')/site/pack/core/opt; lockfile at
-- stdpath('config')/nvim-pack-lock.json (tracked in git).
--
-- Loading semantics: during init.lua sourcing `load` defaults to false (acts
-- like `:packadd!` -- on rtp + require() works, but plugin/ files are NOT
-- sourced). Lua plugins we `require().setup()` ourselves don't care. Vimscript
-- plugins whose plugin/ files provide commands/maps need `load = true`.

local function gh(repo)
	return "https://github.com/" .. repo
end

vim.pack.add({
	-- Colorscheme (loaded + configured first in init.lua)
	{ src = gh("catppuccin/nvim"), name = "catppuccin" },

	-- Completion stack
	{ src = gh("saghen/blink.cmp"), version = vim.version.range("1") },
	{ src = gh("L3MON4D3/LuaSnip"), version = vim.version.range("2") },
	{ src = gh("rafamadriz/friendly-snippets") },
	{ src = gh("folke/lazydev.nvim") },

	-- LSP + tooling
	{ src = gh("neovim/nvim-lspconfig") },
	{ src = gh("mason-org/mason.nvim") },
	{ src = gh("mason-org/mason-lspconfig.nvim") },
	{ src = gh("WhoIsSethDaniel/mason-tool-installer.nvim") },
	{ src = gh("j-hui/fidget.nvim") },
	{ src = gh("mfussenegger/nvim-jdtls") },

	-- Treesitter: core engine + parser manager + textobjects
	-- (the archived nvim-treesitter plugin is intentionally NOT used)
	{ src = gh("romus204/tree-sitter-manager.nvim") },
	{ src = gh("nvim-treesitter/nvim-treesitter-textobjects"), version = "main" },

	-- Editing / format / navigation
	{ src = gh("stevearc/conform.nvim") },
	{ src = gh("ibhagwan/fzf-lua") },
	{ src = gh("stevearc/oil.nvim") },
	{ src = gh("lewis6991/gitsigns.nvim") },
	{ src = gh("folke/trouble.nvim") },
	{ src = gh("folke/which-key.nvim") },
	{ src = gh("kylechui/nvim-surround"), version = vim.version.range("4") },
	{ src = gh("RRethy/vim-illuminate") },

	-- Folding
	{ src = gh("kevinhwang91/nvim-ufo") },
	{ src = gh("kevinhwang91/promise-async") },
	{ src = gh("luukvbaal/statuscol.nvim") },

	-- DAP stack (vim.pack has no auto-dep resolution; nio listed explicitly,
	-- ordered before dap-ui which requires it)
	{ src = gh("nvim-neotest/nvim-nio") },
	{ src = gh("mfussenegger/nvim-dap") },
	{ src = gh("rcarriga/nvim-dap-ui") },
	{ src = gh("mfussenegger/nvim-dap-python") },
	{ src = gh("theHamsta/nvim-dap-virtual-text") },

	-- Shared dependency
	{ src = gh("nvim-tree/nvim-web-devicons") },

	-- Vimscript / command-providing plugins: need load=true so their plugin/
	-- files (commands, <Plug> maps, autocmds) are sourced at startup.
	{ src = gh("tpope/vim-fugitive"), load = true },
	{ src = gh("tpope/vim-rhubarb"), load = true },
	{ src = gh("tpope/vim-sleuth"), load = true },
	{ src = gh("mbbill/undotree"), load = true },
	{ src = gh("christoomey/vim-tmux-navigator"), load = true },

	-- Misc Lua plugins
	{ src = gh("numToStr/Comment.nvim") },
	{ src = gh("echasnovski/mini.move") },
	{ src = gh("echasnovski/mini.statusline") },
})

-- Build hooks. blink.cmp downloads its prebuilt fuzzy binary at runtime inside
-- setup(), so it needs no hook. Only LuaSnip needs a build (optional jsregexp).
vim.api.nvim_create_autocmd("PackChanged", {
	group = vim.api.nvim_create_augroup("pack-build-hooks", { clear = true }),
	callback = function(args)
		local data = args.data
		if data.spec.name == "LuaSnip" and (data.kind == "install" or data.kind == "update") then
			if vim.fn.has("win32") == 0 and vim.fn.executable("make") == 1 then
				vim.notify("[pack] building LuaSnip jsregexp...", vim.log.levels.INFO)
				vim.system({ "make", "install_jsregexp" }, { cwd = data.path }, function(out)
					local level = out.code == 0 and vim.log.levels.INFO or vim.log.levels.WARN
					vim.notify("[pack] LuaSnip jsregexp build exited " .. out.code, level)
				end)
			end
		end
	end,
})
