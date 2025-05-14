---@class tokyonight.Config
return {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("tokyonight").setup({
			---@param highlights tokyonight.Highlights
			---@param colors ColorScheme
			on_highlights = function(highlights, colors)
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

				-- JSX composite components using object notation (e.g., <Modal.Dialog>)
				highlights["@tag.builtin.tsx"] = {
					fg = colors.red,
				}

				-- JSX props
				highlights["@tag.attribute.tsx"] = {
					fg = colors.purple,
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
			end,
		})
	end,
}
