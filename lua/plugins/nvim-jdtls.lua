local env = {
	HOME = vim.uv.os_homedir(),
	XDG_CACHE_HOME = os.getenv("XDG_CACHE_HOME"),
	JDTLS_JVM_ARGS = os.getenv("JDTLS_JVM_ARGS"),
}

local function get_cache_dir()
	return env.XDG_CACHE_HOME and env.XDG_CACHE_HOME or env.HOME .. "/.cache"
end

local function get_jdtls_cache_dir()
	return get_cache_dir() .. "/jdtls"
end

local function get_jdtls_workspace_dir()
	return get_jdtls_cache_dir() .. "/workspace"
end

return {
	"mfussenegger/nvim-jdtls",
	dependencies = {
		"folke/which-key.nvim",
		{ "williamboman/mason.nvim", config = true },
		"mfussenegger/nvim-dap",
		"saghen/blink.cmp",
	},
	ft = { "java" },
	config = function()
		local function attach_jdtls()
			local lombok_jar = vim.fn.expand("$MASON/packages/jdtls/lombok.jar")
			local cmd = vim.lsp.config.jdtls.cmd
			--- @cast cmd string[]
			vim.list_extend(cmd, { string.format("--jvm-arg=-javaagent:%s", lombok_jar) })

			local config = vim.tbl_extend("force", vim.lsp.config.jdtls, {
				cmd = cmd,
				init_options = {
					workspace = get_jdtls_workspace_dir(),
					jvm_args = {},
					os_config = nil,
					settings = {
						java = {
							imports = {
								gradle = {
									wrapper = {
										checksums = {
											{
												sha256 = "7d3a4ac4de1c32b59bc6a4eb8ecb8e612ccd0cf1ae1e99f66902da64df296172",
												allowed = true,
											},
										},
									},
								},
							},
							inlayHints = {
								parameterNames = {
									enabled = "all",
								},
							},
							format = {
								enabled = false,
							},
						},
					},
				},
			})

			require("jdtls").start_or_attach(config)
		end

		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "java" },
			callback = attach_jdtls,
		})

		attach_jdtls()
	end,
}
