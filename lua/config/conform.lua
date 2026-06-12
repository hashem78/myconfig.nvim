-- Autoformat (conform.nvim).
local conform = require("conform")

conform.setup({
	notify_on_error = false,
	formatters = {
		ruff_format = {
			cwd = require("conform.util").root_file({
				"pyproject.toml",
				"ruff.toml",
				".ruff.toml",
			}),
		},
		ruff_fix = {
			cwd = require("conform.util").root_file({
				"pyproject.toml",
				"ruff.toml",
				".ruff.toml",
			}),
		},
		["amazon-java-format"] = {
			command = "amazon-java-format",
			args = {
				"--amazon",
				"--replace",
				"$FILENAME",
			},
			stdin = false,
		},
		["smithy-format"] = {
			command = "smithy",
			args = {
				"format",
				"$FILENAME",
			},
			stdin = false,
		},
	},
	format_on_save = function(bufnr)
		-- Disable "format_on_save lsp_fallback" for languages that don't
		-- have a well standardized coding style.
		local disable_filetypes = { c = true, java = false }
		local lsp_format_opt
		if disable_filetypes[vim.bo[bufnr].filetype] then
			lsp_format_opt = "never"
		else
			lsp_format_opt = "fallback"
		end
		return {
			timeout_ms = 500,
			lsp_format = lsp_format_opt,
		}
	end,
	formatters_by_ft = {
		lua = { "stylua" },
		java = { "amazon-java-format" },
		smithy = { "smithy-format" },
		python = {
			"ruff_fix",
			"ruff_format",
			"ruff_organize_imports",
		},
		javascript = { "prettierd", "prettier", stop_after_first = true },
		typescript = { "prettierd", "prettier", stop_after_first = true },
	},
})

vim.keymap.set("", "<leader>f", function()
	conform.format({ async = true, lsp_format = "fallback" })
end, { desc = "[F]ormat buffer" })
