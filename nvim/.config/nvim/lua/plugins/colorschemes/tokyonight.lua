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
				-- General overrides
				colors.bg_statusline = colors.none
				colors.magenta2 = "#BA3C97" -- Special color from VS Code Tokyonight theme

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
					fg = colors.border_highlight,
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

				-- HTML/JSX/TSX tags
				highlights["@tag"] = {
					fg = colors.red,
				}

				-- JSX/TSX composite components using object notation (e.g., <Modal.Dialog>); normal HTML elements
				highlights["@tag.builtin"] = {
					fg = colors.red,
				}

				-- Angle brackets for HTML elements
				highlights["@tag.delimiter"] = {
					fg = colors.magenta2,
				}

				-- Angle brackets for TSX elements
				highlights["@tag.delimiter.tsx"] = {
					fg = colors.magenta2,
				}

				-- Angle brackets for JSX elements
				highlights["@tag.delimiter.jsx"] = {
					fg = colors.magenta2,
				}

				-- JSX props / HTML attributes
				highlights["@tag.attribute"] = {
					fg = colors.magenta,
					italic = true,
				}

				-- Treesitter hlgroup for built-in "defaultLibrary" tokens
				highlights["@variable.builtin"] = {
					fg = colors.blue1,
				}

				-- Fix the coloring for some built-in utilies (e.g., JS `Reflect`)
				highlights["@lsp.typemod.namespace.defaultLibrary"] = {
					fg = colors.blue1,
				}

				-- Built-in variables/functions - LSP (e.g., vim.--)
				highlights["@lsp.typemod.variable.global"] = {
					fg = colors.blue1,
				}

				-- Methods belonging to built-in variables/functions (these should remain blue)
				highlights["@lsp.typemod.method.defaultLibrary"] = {
					fg = colors.blue,
				}

				-- Functions belonging to built-in classes/namespaces (these should remain blue)
				highlights["@lsp.typemod.function.defaultLibrary"] = {
					fg = colors.blue,
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
