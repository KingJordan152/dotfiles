local nvm_lib_dir = vim.fn.expand("$NVM_BIN/../lib")
local vue_language_server_path = vim.fn.expand("$MASON/packages")
	.. "/vue-language-server"
	.. "/node_modules/@vue/language-server"

---@type vim.lsp.Config
return {
	filetypes = {
		"typescript",
		"javascript",
		"javascriptreact",
		"typescriptreact",
		"vue",
	},
	init_options = {
		plugins = {
			{
				name = "@styled/typescript-styled-plugin",
				-- TODO: Add check for NVM
				location = nvm_lib_dir,
			},
			{
				name = "typescript-svelte-plugin",
				location = nvm_lib_dir,
			},
			{
				name = "@vue/typescript-plugin",
				location = vue_language_server_path,
				languages = { "vue" },
				configNamespace = "typescript",
			},
		},
	},
}
