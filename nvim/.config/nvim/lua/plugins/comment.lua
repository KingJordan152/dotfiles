--[[
-- Expands upon Neovim's default commenting system by adding new keymaps and filling in edge-cases.
-- For example, it adds a motion for applying block comments in addition to single-line comments.
--]]

---@diagnostic disable: missing-fields
return {
	"numToStr/Comment.nvim",
	dependencies = {
		{
			--[[ 
      -- NECESSARY; ensures JSX/TSX files apply correct commentstring based Treesitter node.
      -- e.g., JSX attributes -> '// %s'; JSX Elements -> '{/* %s */}'
      --]]
			"JoosepAlviste/nvim-ts-context-commentstring",
			opts = {
				enable_autocmd = false,
			},
		},
	},
	config = function()
		require("Comment").setup({
			toggler = {
				block = "gbb", -- More closely follows Vim "language" (default is "gbc").
			},
			pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
		})
	end,
}
