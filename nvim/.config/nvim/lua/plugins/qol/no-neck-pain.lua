return {
	"shortcuts/no-neck-pain.nvim",
	version = "*",
	cmd = "NoNeckPain",
	keys = {
		{
			"<leader>zz",
			"<cmd>NoNeckPain<cr>",
			desc = "Center current window",
		},
	},
	config = function()
		require("no-neck-pain").setup({
			width = 110,
			disableOnLastBuffer = true,
			fallbackOnBufferDelete = false,
		})

		vim.api.nvim_create_autocmd("BufEnter", {
			desc = "Remove vertical split lines in markdown files when NoNeckPain is enabled",
			group = vim.api.nvim_create_augroup("markdown_remove_vertical_split_lines", { clear = true }),
			callback = function()
				local filetype = vim.bo.filetype
				if filetype == "markdown" or filetype == "no-neck-pain" then
					vim.opt.fillchars:append({ vert = " " })
				else
					vim.opt.fillchars:append({ vert = "│" })
				end
			end,
		})
	end,
}
