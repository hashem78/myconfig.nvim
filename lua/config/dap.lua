-- Debug adapter protocol stack.
local dap = require("dap")
local ui = require("dapui")

require("dapui").setup()
require("dap-python").setup()
require("nvim-dap-virtual-text").setup({})

vim.keymap.set("n", "<space>b", dap.toggle_breakpoint, { desc = "DAP toggle breakpoint" })
vim.keymap.set("n", "<space>gb", dap.run_to_cursor, { desc = "DAP run to cursor" })

-- Eval var under cursor
vim.keymap.set("n", "<space>g?", function()
	require("dapui").eval(nil, { enter = true })
end, { desc = "DAP eval under cursor" })

vim.keymap.set("n", "<F1>", dap.continue, { desc = "DAP continue" })
vim.keymap.set("n", "<F2>", dap.step_into, { desc = "DAP step into" })
vim.keymap.set("n", "<F3>", dap.step_over, { desc = "DAP step over" })
vim.keymap.set("n", "<F4>", dap.step_out, { desc = "DAP step out" })
vim.keymap.set("n", "<F5>", dap.step_back, { desc = "DAP step back" })
vim.keymap.set("n", "<F6>", dap.close, { desc = "DAP close" })
vim.keymap.set("n", "<F13>", dap.restart, { desc = "DAP restart" })

dap.listeners.before.attach.dapui_config = function()
	ui.open()
end
dap.listeners.before.launch.dapui_config = function()
	ui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
	ui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	ui.close()
end
