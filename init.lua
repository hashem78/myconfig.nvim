vim.o.laststatus = 3
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.cmdheight = 0
vim.opt.swapfile = false
vim.opt.grepprg = "rg --vimgrep"
vim.opt.grepformat = "%f:%l:%c:%m"

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})
require("mappings")

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

require("lazy").setup("plugins")

require("catppuccin").setup({
	compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
	flavour = "mocha",
})
vim.cmd.colorscheme("catppuccin")
