local mason_package_path = vim.fn.stdpath("data") .. "/mason/packages"
local bundles = {
	vim.fn.glob(
		mason_package_path .. "/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar",
		true
	),
}

---@type vim.lsp.Config
return {
	init_options = {
		bundles = bundles,
	},
}
