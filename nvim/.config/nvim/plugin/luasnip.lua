vim.pack.add({
	-- Dependencies
	"https://github.com/rafamadriz/friendly-snippets",

	"https://github.com/L3MON4D3/LuaSnip",
})

local luasnip_vscode = require("luasnip.loaders.from_vscode")
local vscode_dir = vim.fn.getcwd() .. "/.vscode"
local vscode_dir_exists = vim.fn.isdirectory(vscode_dir) == 1

---@type string[]
local code_snippet_files = vscode_dir_exists
		---@diagnostic disable-next-line: param-type-mismatch
		and vim.fn.readdir(vscode_dir, function(name)
			return name:match(".code[-]snippets$") ~= nil and 1 or 0 -- `readdir` only accepts numbers in return
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
