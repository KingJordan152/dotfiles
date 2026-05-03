-- [[
-- Plugin for loading and using snippets from various sources.
-- I'm primarily using it so that I can use both `friendly-snippets` and VS Code snippets
-- that are defined in any project that I'm working on.
-- ]]
return {
	"L3MON4D3/LuaSnip",
	version = "v2.*",
	event = { "InsertEnter", "CmdlineEnter", "TermEnter" },
	dependencies = { "rafamadriz/friendly-snippets" },
	config = function()
		local luasnip_vscode = require("luasnip.loaders.from_vscode")
		local vscode_dir = vim.fn.getcwd() .. "/.vscode"
		local vscode_dir_exists = vim.fn.isdirectory(vscode_dir) == 1

		---@type string[]
		local code_snippet_files = vscode_dir_exists
				---@diagnostic disable-next-line: param-type-mismatch
				and vim.fn.readdir(vscode_dir, function(name)
					return name:match(".code[-]snippets$") ~= nil
				end)
			or {}

		-- Load snippets from `friendly-snippets`
		luasnip_vscode.lazy_load()

		-- Apply snippets from all `.vscode/*.code-snippets` files in the cwd, if they exist.
		-- See https://github.com/L3MON4D3/LuaSnip/issues/1186
		for _, file in ipairs(code_snippet_files) do
			local filepath = vscode_dir .. "/" .. file

			luasnip_vscode.load_standalone({ lazy = true, path = filepath })
		end
	end,
}
