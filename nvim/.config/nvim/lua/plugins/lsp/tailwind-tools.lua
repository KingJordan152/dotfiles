return {
	"luckasRanarison/tailwind-tools.nvim",
	name = "tailwind-tools",
	build = ":UpdateRemotePlugins",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-telescope/telescope.nvim",
		"neovim/nvim-lspconfig",
	},
	config = function()
		require("tailwind-tools").setup({
			---@diagnostic disable-next-line: missing-fields
			server = {
				-- Setup default keymaps and commands here, otherwise they'll be applied to EVERY JavaScript project, regardless of whether they have Tailwind installed.
				on_attach = function()
					vim.keymap.set(
						"n",
						"<leader>tt",
						"<Cmd>TailwindConcealToggle<CR>",
						{ desc = "Toggle Tailwind class concealment" }
					)

					-- Automatically conceal Tailwind classes when entering a Tailwind project
					vim.cmd(":TailwindConcealEnable")
				end,
			},
			document_color = {
				kind = "background",
			},
		})
	end,
}
