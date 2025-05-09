-- Sourced from https://github.com/neovim/nvim-lspconfig/blob/master/lsp/ts_ls.lua
return {
	init_options = { hostInfo = "neovim" },
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
	},
	root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
	single_file_support = true,
}
