return {
	'kevinhwang91/nvim-ufo',
	dependencies = {
		'kevinhwang91/promise-async',
		{
			"luukvbaal/statuscol.nvim",
			config = function()
				local builtin = require("statuscol.builtin")
				require("statuscol").setup(
					{
						relculright = true,
						segments = {
							{ text = { builtin.foldfunc },      click = "v:lua.ScFa" },
							{ text = { "%s" },                  click = "v:lua.ScSa" },
							{ text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" }
						}
					}
				)
			end
		}
	},
	opts = {
		provider_selector = function(bufnr, filetype, buftype)
			return { 'lsp', 'indent' }
		end
	},
	config = function(spec, opts)
		require('ufo').setup(opts)

		vim.o.foldcolumn = '1' -- '0' is not bad
		vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
		vim.o.foldlevelstart = 99
		vim.o.foldenable = true
		vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
		-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
		vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
		vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
		vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds)
		vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith) -- closeAllFolds == closeFoldsWith(0)
		vim.keymap.set('n', 'zK', function()
			local winid = require('ufo').peekFoldedLinesUnderCursor()
			if not winid then
				-- choose one of coc.nvim and nvim lsp
				vim.fn.CocActionAsync('definitionHover') -- coc.nvim
				vim.lsp.buf.hover()
			end
		end, { desc = 'Peek Folded Lines Under Cursor' })
	end
}
