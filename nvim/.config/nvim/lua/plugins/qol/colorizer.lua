return {
	"norcalli/nvim-colorizer.lua",
	-- Allows `termguicolors` to be set before this plugin is activated
	event = { "BufEnter" },
	config = function()
		-- Doesn't work unless I explicitly call setup like this
		require("colorizer").setup()
	end,
}
