local nvm_path = vim.fn.expand("$NVM_BIN/../lib")

local vue_language_server_path = vim.fn.expand("$MASON/packages")
	.. "/vue-language-server"
	.. "/node_modules/@vue/language-server"

local svelte_language_server_path = vim.fn.expand("$MASON/packages")
	.. "/svelte-language-server"
	.. "/node_modules/typescript-svelte-plugin"

local styled_components_plugin_path = (vim.fn.isdirectory(nvm_path) and nvm_path or "/usr/local/lib") .. "/node_modules"

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
	location = styled_components_plugin_path,
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
			autoUseWorkspaceTsdk = vim.bo.filetype ~= "vue", -- Currently a bug with Vue's default workspace TypeScript version
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
