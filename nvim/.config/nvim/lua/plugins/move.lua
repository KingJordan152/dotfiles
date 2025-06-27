return {
	"fedepujol/move.nvim",
	keys = {
		-- Normal Mode
		{ "<A-j>", ":MoveLine(1)<CR>", desc = "Move Line Up" },
		{ "<A-k>", ":MoveLine(-1)<CR>", desc = "Move Line Down" },
		{ "<A-h>", ":MoveHChar(-1)<CR>", desc = "Move Character Left" },
		{ "<A-l>", ":MoveHChar(1)<CR>", desc = "Move Character Right" },
		-- Visual Mode
		{ "<A-j>", ":MoveBlock(1)<CR>", mode = { "x" }, desc = "Move Block Up" },
		{ "<A-k>", ":MoveBlock(-1)<CR>", mode = { "x" }, desc = "Move Block Down" },
		{ "<A-h>", ":MoveHBlock(-1)<CR>", mode = { "x" }, desc = "Move Block Left" },
		{ "<A-l>", ":MoveHBlock(1)<CR>", mode = { "x" }, desc = "Move Block Right" },
	},
	opts = {
		char = {
			enable = true,
		},
	},
}
