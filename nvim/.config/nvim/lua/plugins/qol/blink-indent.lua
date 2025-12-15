return {
	"saghen/blink.indent",
	enabled = false,
	--- @module 'blink.indent'
	--- @type blink.indent.Config
	opts = {
		static = {
			enabled = true,
			char = "▏",
		},
		scope = {
			enabled = true,
			char = "▏",
			highlights = {
				"BlinkIndentBlue",
				"BlinkIndentCyan",
				"BlinkIndentViolet",
				"BlinkIndentGreen",
				"BlinkIndentYellow",
				"BlinkIndentOrange",
				"BlinkIndentRed",
			},

			underline = {
				enabled = true,
				highlights = {
					"BlinkIndentBlueUnderline",
					"BlinkIndentCyanUnderline",
					"BlinkIndentVioletUnderline",
					"BlinkIndentGreenUnderline",
					"BlinkIndentYellowUnderline",
					"BlinkIndentOrangeUnderline",
					"BlinkIndentRedUnderline",
				},
			},
		},
	},
}
