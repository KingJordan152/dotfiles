---@class tokyonight.Config
return {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		local util = require("tokyonight.util")
		local git_staged_darken_amount = 0.4
		local git_inline_diff_darken_amount = 0.5

		require("tokyonight").setup({
			lualine_bold = true,

			on_colors = function(colors)
				colors.bg_statusline = colors.none

				-- Git overrides
				colors.git.change = colors.yellow
				colors.git.delete = colors.red
			end,

			---@param highlights tokyonight.Highlights
			---@param colors ColorScheme
			on_highlights = function(highlights, colors)
				highlights["GitSignsStagedAdd"] = {
					fg = util.darken(colors.git.add, git_staged_darken_amount),
				}

				highlights["GitSignsStagedChange"] = {
					fg = util.darken(colors.git.change, git_staged_darken_amount),
				}

				highlights["GitSignsStagedDelete"] = {
					fg = util.darken(colors.git.delete, git_staged_darken_amount),
				}

				highlights["GitSignsStagedTopdelete"] = {
					link = "GitSignsStagedDelete",
				}

				highlights["GitSignsChangeInline"] = {
					bg = util.darken(colors.git.add, git_inline_diff_darken_amount),
				}

				highlights["GitSignsDeleteInline"] = {
					bg = util.darken(colors.git.delete, git_inline_diff_darken_amount),
				}

				highlights["RainbowDelimiterGreen"] = {
					fg = util.darken(colors.green, 0.8),
				}

				highlights["MatchParen"] = {
					link = "LspReferenceRead",
				}

				highlights["WinSeparator"] = {
					fg = colors.blue,
				}

				highlights["DapStoppedLine"] = {
					bg = colors.blue7,
				}

				highlights["@variable"] = {
					fg = colors.red,
				}

				highlights["@variable.parameter"] = {
					fg = colors.red,
					italic = true,
				}

				-- Constants (Treesitter)
				highlights["@constant"] = {
					fg = colors.yellow,
				}

				-- Constants (LSP)
				highlights["@lsp.typemod.variable.readonly"] = {
					fg = colors.yellow,
				}

				-- JSX composite components using object notation (e.g., <Modal.Dialog>); normal HTML elements
				highlights["@tag.builtin"] = {
					fg = colors.red,
				}

				-- JSX Elements
				highlights["@_jsx_element"] = {
					fg = colors.red,
				}

				-- Angle brackets for JSX and HTML elements
				highlights["@tag.delimiter.tsx"] = {
					fg = "#BA3C97", -- Special color from VS Code Tokyonight theme
				}

				-- JSX props
				highlights["@tag.attribute"] = {
					fg = colors.magenta,
					italic = true,
				}

				-- Builtin variables/functions (e.g., console.log)
				highlights["@variable.builtin"] = {
					fg = colors.blue1,
				}

				-- Builtin variables/functions - LSP (e.g., vim.--)
				highlights["@lsp.typemod.variable.global"] = {
					fg = colors.blue1,
				}

				-- Default bracket color (when rainbow-delimiters isn't working)
				highlights["@punctuation.bracket"] = {
					fg = colors.purple,
				}

				-- Language-specific keywords (e.g., `null`, `undefined`)
				highlights["@constant.builtin"] = {
					fg = colors.orange,
				}
				-- CSS value keywords (e.g., `flex`, `nowrap`, etc.)
				highlights["@string.css"] = {
					fg = colors.orange,
				}

				highlights["@string.scss"] = {
					fg = colors.orange,
				}
				highlights["@character.special.css"] = {
					fg = colors.yellow,
				}

				highlights["@character.special.scss"] = {
					fg = colors.yellow,
				}
				highlights["@keyword.import.scss"] = {
					fg = colors.purple,
				}

				highlights["@keyword.directive.css"] = {
					fg = colors.purple,
				}

				highlights["@keyword.directive.scss"] = {
					fg = colors.purple,
				}
			end,
		})
	end,
}
