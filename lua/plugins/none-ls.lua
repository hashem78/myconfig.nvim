return {
	"nvimtools/none-ls.nvim",
	config = function()
		local none_ls = require("null-ls");
		none_ls.setup(
			{
				sources = {
					none_ls.builtins.formatting.black,
					none_ls.builtins.diagnostics.mypy,
					none_ls.builtins.formatting.shfmt,
				}
			}
		);
	end,
	dependencies = {
		"nvim-lua/plenary.nvim",
	}
}
