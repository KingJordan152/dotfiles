---@diagnostic disable: missing-fields
return {
	"andymass/vim-matchup",
	config = function()
		require("match-up").setup({
			delim = {
				noskips = 1, -- Match parens but not words like `for` and `end` within comments
			},
			matchparen = {
				deferred = 1, -- Improve performance
				hi_surround_always = 1, -- Keep highlight active when inside (but not directly on) matching pair
				offscreen = {}, -- Prevents statusline flickering
			},
			motion = {
				cursor_end = 0, -- Move cursor to beginning of word-based matches rather than the end
			},
			treesitter = {
				disable_virtual_text = true, -- Prevent virtual text from appearing for languages that don't have well-defined matching pairs (e.g., Python)
				stopline = 500, -- Stop trying to find matching pair after 500 lines
			},
		})
	end,
}
