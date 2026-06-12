-- Java LSP via nvim-jdtls (owns its own lifecycle; NOT vim.lsp.enable'd).
-- bemol workspace folders are loaded in the shared LspAttach (config/lsp.lua).

-- Per-project jdtls data dir (a shared workspace corrupts indexes across repos).
local function workspace_data_dir()
	local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
	return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/workspace"
end

local function brazil_workspace_root()
	return vim.fs.root(0, { "packageInfo" })
end

-- Discover the highest-versioned JDK shipped inside a Brazil workspace
-- (env/JDK<n>/runtime/jdk<...>). Returns home, version or nil, nil.
local function discover_brazil_jdk()
	local ws_root = brazil_workspace_root()
	if not ws_root then
		return nil, nil
	end

	local env_path = ws_root .. "/env"
	local scanner = vim.uv.fs_scandir(env_path)
	if not scanner then
		return nil, nil
	end

	local jdk_home, jdk_version = nil, 0

	while true do
		local entry_name, entry_type = vim.uv.fs_scandir_next(scanner)
		if not entry_name then
			break
		end

		if entry_type == "directory" then
			local version = entry_name:match("^JDK(%d+)")
			if version and tonumber(version) > jdk_version then
				local runtime_path = env_path .. "/" .. entry_name .. "/runtime"
				local runtime_scanner = vim.uv.fs_scandir(runtime_path)
				if runtime_scanner then
					while true do
						local runtime_entry = vim.uv.fs_scandir_next(runtime_scanner)
						if not runtime_entry then
							break
						end
						if runtime_entry:match("^jdk") then
							jdk_home = runtime_path .. "/" .. runtime_entry
							jdk_version = tonumber(version)
						end
					end
				end
			end
		end
	end

	return jdk_home, jdk_version
end

-- macOS JDK fallback: resolve via java_home so we don't hardcode a path.
local function macos_java_home(version)
	local out = vim.fn.system({ "/usr/libexec/java_home", "-v", tostring(version) })
	if vim.v.shell_error == 0 then
		return vim.trim(out)
	end
	return nil
end

local function attach_jdtls()
	local root_dir = vim.fs.root(0, { ".classpath", "packageInfo", "build.gradle.kts", ".git" })
	if not root_dir then
		return
	end

	local lombok_jar = vim.fn.expand("$MASON/packages/jdtls/lombok.jar")
	local brazil_jdk_home, brazil_jdk_version = discover_brazil_jdk()
	local fallback_home = macos_java_home(21)

	local runtimes = {}
	if brazil_jdk_home and brazil_jdk_version then
		table.insert(runtimes, {
			name = "JavaSE-" .. brazil_jdk_version,
			path = brazil_jdk_home,
			default = true,
		})
	end
	if fallback_home then
		table.insert(runtimes, {
			name = "JavaSE-21",
			path = fallback_home,
		})
	end

	local gradle_java_home = brazil_jdk_home or fallback_home

	-- vim.lsp.config.jdtls returns the resolved base config (from
	-- nvim-lspconfig's bundled lsp/jdtls.lua); merge our overrides on top.
	local config = vim.tbl_extend("force", vim.lsp.config.jdtls, {
		cmd = {
			"jdtls",
			string.format("--jvm-arg=-javaagent:%s", lombok_jar),
			"-data",
			workspace_data_dir(),
		},
		root_dir = root_dir,
		-- jdtls reads these from the top-level `settings` table (sent via
		-- workspace/didChangeConfiguration), NOT from init_options.settings.
		settings = {
			java = {
				configuration = {
					runtimes = runtimes,
				},
				import = {
					gradle = {
						java = { home = gradle_java_home },
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
	})

	require("jdtls").start_or_attach(config)
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "java" },
	callback = attach_jdtls,
})
