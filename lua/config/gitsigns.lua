-- Git gutter signs + hunk actions.
require("gitsigns").setup({
	signs = {
		add = { text = "+" },
		change = { text = "~" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
	},
	on_attach = function(bufnr)
		local gs = require("gitsigns")

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		-- Navigation (nav_hunk replaces deprecated next_hunk/prev_hunk).
		map({ "n", "v" }, "]c", function()
			if vim.wo.diff then
				return "]c"
			end
			vim.schedule(function()
				gs.nav_hunk("next")
			end)
			return "<Ignore>"
		end, { expr = true, desc = "Jump to next hunk" })

		map({ "n", "v" }, "[c", function()
			if vim.wo.diff then
				return "[c"
			end
			vim.schedule(function()
				gs.nav_hunk("prev")
			end)
			return "<Ignore>"
		end, { expr = true, desc = "Jump to previous hunk" })

		-- Actions (visual)
		map("v", "<leader>hs", function()
			gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "stage git hunk" })
		map("v", "<leader>hr", function()
			gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "reset git hunk" })

		-- Actions (normal). stage_hunk now toggles staged hunks, so <leader>hu
		-- (formerly undo_stage_hunk) maps to stage_hunk too.
		map("n", "<leader>hs", gs.stage_hunk, { desc = "git stage hunk" })
		map("n", "<leader>hr", gs.reset_hunk, { desc = "git reset hunk" })
		map("n", "<leader>hS", gs.stage_buffer, { desc = "git Stage buffer" })
		map("n", "<leader>hu", gs.stage_hunk, { desc = "git (un)stage hunk" })
		map("n", "<leader>hR", gs.reset_buffer, { desc = "git Reset buffer" })
		map("n", "<leader>hp", gs.preview_hunk, { desc = "preview git hunk" })
		map("n", "<leader>hb", function()
			gs.blame_line({ full = false })
		end, { desc = "git blame line" })
		map("n", "<leader>hd", gs.diffthis, { desc = "git diff against index" })
		map("n", "<leader>hD", function()
			gs.diffthis("~")
		end, { desc = "git diff against last commit" })

		-- Toggles (toggle_deleted deprecated -> preview_hunk_inline).
		map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "toggle git blame line" })
		map("n", "<leader>td", gs.preview_hunk_inline, { desc = "preview deleted hunk inline" })

		-- Text object
		map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "select git hunk" })
	end,
})
