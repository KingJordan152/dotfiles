return {
	"kylechui/nvim-surround",
	version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
	event = "VeryLazy",
	config = function()
		require("nvim-surround").setup({
			move_cursor = "sticky",
		})

		-- Set up convenient Markdown-based text-formatting shortcuts for all modes
		vim.keymap.set("n", "<leader>m", "", { desc = "Markdown format" })

		-- Normal mode mappings
		vim.keymap.set("n", "<leader>mi", "ysiw_", { remap = true, desc = "Italicize word" })
		vim.keymap.set("n", "<leader>mb", "2ysiw*", { remap = true, desc = "Bold word" })
		vim.keymap.set("n", "<leader>mc", "ysiw`", { remap = true, desc = "Inline-Code word" })
		vim.keymap.set("n", "<leader>ms", "2ysiw~", { remap = true, desc = "Strikethrough word" })

		-- Visual mode mappings
		vim.keymap.set("x", "<leader>mi", "S_", { remap = true, desc = "Italicize selection" })
		vim.keymap.set("x", "<leader>mb", "2S*", { remap = true, desc = "Bold selection" })
		vim.keymap.set("x", "<leader>mc", "S`", { remap = true, desc = "Inline-Code selection" })
		vim.keymap.set("x", "<leader>ms", "2S~", { remap = true, desc = "Strikethrough selection" })

		-- Insert mode mappings (using Meta to make platform-agnostic)
		vim.keymap.set("i", "<M-i>", "<C-g>s_", { remap = true, desc = "Start italics" })
		vim.keymap.set("i", "<M-b>", "<C-g>s*<C-g>s*", { remap = true, desc = "Start bold" })
		vim.keymap.set("i", "<M-c>", "<C-g>s`", { remap = true, desc = "Start inline-code" })
		vim.keymap.set("i", "<M-s>", "<C-g>s~<C-g>s~", { remap = true, desc = "Start strikethrough" })
	end,
}
