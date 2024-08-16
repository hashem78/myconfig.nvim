return {
	"catppuccin/nvim",
	-- lazy = false,
	event = "VeryLazy",
	name = "catppuccin",
	priority = 1000,
	config = function()
		require("catppuccin").setup()

		vim.cmd.colorscheme("catppuccin")
	end,
}
