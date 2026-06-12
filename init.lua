-- Neovim 0.12 config, managed with native vim.pack.
-- Trial via: NVIM_APPNAME=nvim-next nvim   (requires `bob use 0.12.3`)

vim.o.laststatus = 3
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.cmdheight = 0
vim.opt.swapfile = false
vim.opt.grepprg = "rg --vimgrep"
vim.opt.grepformat = "%f:%l:%c:%m"

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- Install/declare all plugins (vim.pack). Must come before requires below.
require("pack")

-- Editor options + non-plugin keymaps.
require("mappings")

-- Highlight on yank (vim.hl replaces the deprecated vim.highlight on 0.12).
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.hl.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

-- Diagnostics: gutter sign text (the modern, sign_define-free way).
local signs = {
	Error = "󰅚 ",
	Warn = "󰀪 ",
	Hint = "󰋽 ",
	Info = "󰌶 ",
}
vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = signs.Error,
			[vim.diagnostic.severity.WARN] = signs.Warn,
			[vim.diagnostic.severity.HINT] = signs.Hint,
			[vim.diagnostic.severity.INFO] = signs.Info,
		},
	},
})

-- Colorscheme (configure + apply early so later UI plugins pick it up).
require("catppuccin").setup({
	compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
	flavour = "mocha",
})
vim.cmd.colorscheme("catppuccin")

-- Experimental core UI (ui2): redesigned messages/cmdline.
require("config.ui2")

-- Plugin configuration modules.
require("config.lsp")
require("config.blink")
require("config.lazydev")
require("config.treesitter")
require("config.conform")
require("config.fzf")
require("config.oil")
require("config.gitsigns")
require("config.ufo")
require("config.trouble")
require("config.which-key")
require("config.dap")
require("config.jdtls")
require("config.surround")
require("config.illuminate")
require("config.misc")
