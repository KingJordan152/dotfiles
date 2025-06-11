-- [[
-- Plugin for loading and using snippets from various sources.
-- I'm primarily using it so that I can use both `friendly-snippets` and VS Code snippets
-- that are declared in any project that I'm working on.
-- ]]
return {
	"L3MON4D3/LuaSnip",
	version = "v2.*",
	dependencies = { "rafamadriz/friendly-snippets" },
	config = function()
		-- Load snippets from `friendly-snippets`
		require("luasnip.loaders.from_vscode").lazy_load()

		-- Apply snippets from all `.vscode/*.code-snippets` files in the cwd.
		-- Code sourced from https://github.com/erlangparasu/dot-config-nvim/blob/6146f6edbd99225c7d74c12b1e769ad4ebd6c6a9/lua/config/autocmds.lua#L55
		-- local plenary = require("plenary.scandir")
		-- local cwd = vim.fn.getcwd()
		--
		-- local files = plenary.scan_dir(cwd .. "/.vscode", {
		-- 	depth = 2,
		-- 	hidden = true,
		-- 	search_pattern = ".code[-]snippets$", -- extension ".code-snippets"
		-- })
		--
		-- if #files > 0 then
		-- 	for _, file in ipairs(files) do
		-- 		local text1 = file
		-- 		local substring1 = ".code-snippets"
		--
		-- 		if string.find(text1, substring1, 0, true) ~= nil then
		-- 			require("luasnip.loaders.from_vscode").load_standalone({ lazy = true, path = file })
		-- 		end
		-- 	end
		-- end
	end,
}
