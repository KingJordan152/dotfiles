return {
	"fedepujol/move.nvim",
	keys = {
		-- Normal Mode
		{ "<A-j>", ":MoveLine(1)<CR>", desc = "Move Line Up", silent = true },
		{ "<A-k>", ":MoveLine(-1)<CR>", desc = "Move Line Down", silent = true },
		{ "<A-h>", ":MoveHChar(-1)<CR>", desc = "Move Character Left", silent = true },
		{ "<A-l>", ":MoveHChar(1)<CR>", desc = "Move Character Right", silent = true },
		-- Visual Mode
		{ "<A-j>", ":MoveBlock(1)<CR>", mode = { "x" }, desc = "Move Block Up", silent = true },
		{ "<A-k>", ":MoveBlock(-1)<CR>", mode = { "x" }, desc = "Move Block Down", silent = true },
		{ "<A-h>", ":MoveHBlock(-1)<CR>", mode = { "x" }, desc = "Move Block Left", silent = true },
		{ "<A-l>", ":MoveHBlock(1)<CR>", mode = { "x" }, desc = "Move Block Right", silent = true },
	},
	opts = {
		char = {
			enable = true,
		},
	},
}
