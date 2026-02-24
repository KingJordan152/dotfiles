local npm_global_install_path = vim.trim(
	vim.system({ "npm", "config", "get", "prefix" }, { text = true }):wait().stdout
) .. "/lib"

local vue_language_server_path = vim.fn.expand("$MASON/packages")
	.. "/vue-language-server"
	.. "/node_modules/@vue/language-server"

local svelte_language_server_path = vim.fn.expand("$MASON/packages")
	.. "/svelte-language-server"
	.. "/node_modules/typescript-svelte-plugin"

local vue_plugin = {
	name = "@vue/typescript-plugin",
	location = vue_language_server_path,
	languages = { "vue" },
	configNamespace = "typescript",
	enableForWorkspaceTypeScriptVersions = true,
}

local svelte_plugin = {
	name = "typescript-svelte-plugin",
	location = svelte_language_server_path,
	enableForWorkspaceTypeScriptVersions = true,
}

local styled_components_plugin = {
	name = "@styled/typescript-styled-plugin",
	location = npm_global_install_path,
	enableForWorkspaceTypeScriptVersions = true,
}

---@type vim.lsp.Config
return {
	filetypes = {
		"typescript",
		"javascript",
		"javascriptreact",
		"typescriptreact",
		"vue",
	},
	settings = {
		vtsls = {
			autoUseWorkspaceTsdk = true,
			tsserver = {
				maxTsServerMemory = 8092, -- 8 GiB
				globalPlugins = {
					vue_plugin,
					svelte_plugin,
					styled_components_plugin,
				},
			},
			experimental = {
				completion = {
					enableServerSideFuzzyMatch = true,
				},
			},
		},
		typescript = {
			preferences = {
				preferTypeOnlyAutoImports = true,
			},
		},
	},
	on_attach = function(client, bufnr)
		vim.api.nvim_buf_create_user_command(bufnr, "SelectTypeScriptVersion", function()
			client:request_sync("workspace/executeCommand", {
				command = "typescript.selectTypeScriptVersion",
			}, nil, bufnr)
		end, { desc = "Prompt the user for their preferred TypeScript version" })
	end,
}
