return {
	"ibhagwan/fzf-lua",
	-- optional for icon support
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		-- "telescope",
	},
	config = function(_, opts)
		-- calling `setup` is optional for customization
		local fzfLua = require("fzf-lua")

		vim.keymap.set('n', '<leader>?', fzfLua.oldfiles, { desc = '[?] Find recently opened files' })
		vim.keymap.set('n', '<leader><space>', fzfLua.buffers, { desc = '[ ] Find existing buffers' })

		vim.keymap.set('n', '<leader>ss', fzfLua.builtin, { desc = '[S]earch [S]elect Telescope' })
		vim.keymap.set('n', '<leader>gf', fzfLua.git_files, { desc = 'Search [G]it [F]iles' })
		vim.keymap.set('n', '<leader>sf', fzfLua.files, { desc = '[S]earch [F]iles' })
		vim.keymap.set('n', '<leader>sh', fzfLua.help_tags, { desc = '[S]earch [H]elp' })
		vim.keymap.set('n', '<leader>sw', fzfLua.grep_cword, { desc = '[S]earch current [W]ord' })
		vim.keymap.set('n', '<leader>sg', fzfLua.live_grep, { desc = '[S]earch by [G]rep' })
		vim.keymap.set('n', '<leader>sr', fzfLua.resume, { desc = '[S]earch [R]esume' })
		vim.keymap.set('n', '<leader>qf', fzfLua.quickfix, { desc = '[S]earch [R]esume' })

		fzfLua.setup(opts)
	end
}
