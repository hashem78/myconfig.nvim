-- Experimental 0.12 message/cmdline UI redesign (ui2): no "Press ENTER"
-- interruptions, highlighted cmdline, buffer-based pager. Pairs well with
-- cmdheight=0. Lives under the unstable vim._core namespace, so guard it with
-- pcall -- if the path/API changes in a future Neovim, we just skip it.
local ok, ui2 = pcall(require, "vim._core.ui2")
if not ok then
	return
end

pcall(ui2.enable, {
	msg = {
		-- Default target for any kind not listed in `targets`.
		target = "msg",
		-- Per-kind routing. Kinds are |ui-messages| event kinds.
		targets = {
			-- Inline in the cmdline: search as you type + match counter.
			search_cmd = "cmd",
			search_count = "cmd",
			-- Notification box (bottom-right, auto-dismiss): errors, warnings,
			-- echo/notifications, write messages.
			emsg = "msg",
			echoerr = "msg",
			echomsg = "msg",
			echo = "msg",
			lua_error = "msg",
			rpc_error = "msg",
			wmsg = "msg",
			bufwrite = "msg",
			-- Scrollable pager: long multi-line output worth reading/searching.
			list_cmd = "pager",
			verbose = "pager",
			shell_out = "pager",
			shell_err = "pager",
			quickfix = "pager",
		},
		msg = {
			height = 0.5,
			timeout = 4000,
		},
	},
})

-- Tie the ui2 windows into the catppuccin float look. Each window's buffer
-- filetype is its id ("cmd"/"msg"/"pager"/"dialog").
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("ui2-style", { clear = true }),
	pattern = { "cmd", "msg", "pager", "dialog" },
	callback = function()
		vim.wo[0].winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder"
	end,
})

-- tiny-cmdline repositions the ui2 cmdline window on CmdlineEnter. Place it
-- centered, just above the statusline (search stays pinned to the bottom).
pcall(function()
	require("tiny-cmdline").setup({
		width = { value = "60%", min = 40, max = 100 },
		position = { x = "50%", y = "95%" },
		border = "single", -- straight box-drawing border, square corners
	})
end)
