local utils = require("core.utils")

return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	enabled = function()
		return utils.tree_sitter_cli_exists(true)
	end,
	config = function()
		local ts = require("nvim-treesitter")

		-- Ensure the following parsers are immediately installed
		ts.install({
			"lua",
			"luadoc",
			"tsx",
			"typescript",
			"javascript",
			"jsdoc",
			"html",
			"css",
			"styled", -- For styled-components
			"markdown",
			"markdown_inline",
			"yaml",
			"regex", -- For certain pickers
			"latex",
			"query",
			"gitcommit",
			"c",
		})

		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("treesitter.setup", {}),
			callback = function(args)
				local buf = args.buf
				local filetype = args.match
				local language = vim.treesitter.language.get_lang(filetype) or filetype

				-- Prevents Treesitter from running on buffers that don't correspond to an available language/parser
				if not vim.tbl_contains(ts.get_available(), language) then
					return
				end

				-- Auto-install a language; already installed languages are ignored
				ts.install(language):await(function()
					-- Enable highlighting
					vim.treesitter.start(buf, language)

					-- Enable folds
					vim.wo.foldmethod = "expr"
					vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"

					-- Enable indents
					vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end)
			end,
		})
	end,
}
