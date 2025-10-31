return {
	"shortcuts/no-neck-pain.nvim",
	version = "*",
	cmd = "NoNeckPain",
	keys = {
		{
			"<leader>zz",
			"<cmd>:NoNeckPain<cr>",
			desc = "Center current window",
		},
	},
	config = function()
		require("no-neck-pain").setup({
			width = 110,
			disableOnLastBuffer = true,
			fallbackOnBufferDelete = false,
			callbacks = {
				postEnable = function()
					if vim.bo.filetype == "markdown" then
						vim.opt.fillchars:append({ vert = " " })
					end
				end,
				postDisable = function()
					vim.opt.fillchars:append({ vert = "│" })
				end,
			},
		})
	end,
}
