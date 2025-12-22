local utils = require("core.utils")

return {
	"nvim-treesitter/nvim-treesitter-textobjects",
	enabled = utils.tree_sitter_cli_exists,
	branch = "main",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	init = function()
		-- Disable entire built-in ftplugin mappings to avoid conflicts.
		-- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
		vim.g.no_plugin_maps = true
	end,
	config = function()
		require("nvim-treesitter-textobjects").setup({
			select = {
				-- Makes custom textobjects work more closely to native textobjects
				lookahead = true,
				include_surrounding_whitespace = true,

				selection_modes = {
					["@function.outer"] = "V",
					["@class.outer"] = "V",
				},
			},
			move = {
				set_jumps = true,
			},
		})
	end,
	keys = {
		-- Swap
		{
			"<leader>Xa",
			function()
				require("nvim-treesitter-textobjects.swap").swap_next("@attribute.outer")
			end,
			desc = "Next attribute",
		},
		{
			"<leader>XA",
			function()
				require("nvim-treesitter-textobjects.swap").swap_previous("@attribute.outer")
			end,
			desc = "Previous attribute",
		},
		{
			"<leader>Xr",
			function()
				require("nvim-treesitter-textobjects.swap").swap_next("@parameter.outer")
			end,
			desc = "Next pa[r]ameter/a[r]gument",
		},
		{
			"<leader>XR",
			function()
				require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.outer")
			end,
			desc = "Previous pa[r]ameter/a[r]gument",
		},
		-- Selections
		{
			"af",
			function()
				require("nvim-treesitter-textobjects.select").select_textobject("@call.outer", "textobjects")
			end,
			mode = { "x", "o" },
			desc = "function call",
		},
		{
			"if",
			function()
				require("nvim-treesitter-textobjects.select").select_textobject("@call.inner", "textobjects")
			end,
			mode = { "x", "o" },
			desc = "inner function call",
		},
		{
			"am",
			function()
				require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
			end,
			mode = { "x", "o" },
			desc = "method",
		},
		{
			"im",
			function()
				require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
			end,
			mode = { "x", "o" },
			desc = "inner method",
		},
		{
			"ac",
			function()
				require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
			end,
			mode = { "x", "o" },
			desc = "class",
		},
		{
			"ic",
			function()
				require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
			end,
			mode = { "x", "o" },
			desc = "inner class",
		},
		{
			"aa",
			function()
				require("nvim-treesitter-textobjects.select").select_textobject("@attribute.outer", "textobjects")
			end,
			mode = { "x", "o" },
			desc = "attribute",
		},
		{
			"ia",
			function()
				require("nvim-treesitter-textobjects.select").select_textobject("@attribute.inner", "textobjects")
			end,
			mode = { "x", "o" },
			desc = "inner attribute",
		},
		{
			"ar",
			function()
				require("nvim-treesitter-textobjects.select").select_textobject("@parameter.outer", "textobjects")
			end,
			mode = { "x", "o" },
			desc = "pa[r]ameter/a[r]gument",
		},
		{
			"ir",
			function()
				require("nvim-treesitter-textobjects.select").select_textobject("@parameter.inner", "textobjects")
			end,
			mode = { "x", "o" },
			desc = "inner pa[r]ameter/a[r]gument",
		},
		{
			"a?",
			function()
				require("nvim-treesitter-textobjects.select").select_textobject("@conditional.outer", "textobjects")
			end,
			mode = { "x", "o" },
			desc = "conditional",
		},
		{
			"i?",
			function()
				require("nvim-treesitter-textobjects.select").select_textobject("@conditional.inner", "textobjects")
			end,
			mode = { "x", "o" },
			desc = "conditional",
		},

		-- Movements (start)
		{
			"]f",
			function()
				require("nvim-treesitter-textobjects.move").goto_next_start("@call.outer", "textobjects")
			end,
			mode = { "n", "x", "o" },
			desc = "Next function call start",
		},
		{
			"[f",
			function()
				require("nvim-treesitter-textobjects.move").goto_previous_start("@call.outer", "textobjects")
			end,
			mode = { "n", "x", "o" },
			desc = "Previous function call start",
		},
		{
			"]m",
			function()
				require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
			end,
			mode = { "n", "x", "o" },
			desc = "Next method start",
		},
		{
			"[m",
			function()
				require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
			end,
			mode = { "n", "x", "o" },
			desc = "Previous method start",
		},
		{
			"]c",
			function()
				require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
			end,
			mode = { "n", "x", "o" },
			desc = "Next class start",
		},
		{
			"[c",
			function()
				require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
			end,
			mode = { "n", "x", "o" },
			desc = "Previous class start",
		},
		{
			"]a",
			function()
				require("nvim-treesitter-textobjects.move").goto_next_start("@attribute.outer", "textobjects")
			end,
			mode = { "n", "x", "o" },
			desc = "Next attribute start",
		},
		{
			"[a",
			function()
				require("nvim-treesitter-textobjects.move").goto_previous_start("@attribute.outer", "textobjects")
			end,
			mode = { "n", "x", "o" },
			desc = "Previous attribute start",
		},
		{
			"]r",
			function()
				require("nvim-treesitter-textobjects.move").goto_next_start("@argument.outer", "textobjects")
			end,
			mode = { "n", "x", "o" },
			desc = "Next pa[r]ameter/a[r]gument start",
		},
		{
			"[r",
			function()
				require("nvim-treesitter-textobjects.move").goto_previous_start("@argument.outer", "textobjects")
			end,
			mode = { "n", "x", "o" },
			desc = "Previous pa[r]ameter/a[r]gument start",
		},
		{
			"]?",
			function()
				require("nvim-treesitter-textobjects.move").goto_next_start("@conditional.outer", "textobjects")
			end,
			mode = { "n", "x", "o" },
			desc = "Next conditional start",
		},
		{
			"[?",
			function()
				require("nvim-treesitter-textobjects.move").goto_next_end("@conditional.outer", "textobjects")
			end,
			mode = { "n", "x", "o" },
			desc = "Next conditional end",
		},
		{
			"]/",
			function()
				require("nvim-treesitter-textobjects.move").goto_next_start("@comment.outer", "textobjects")
			end,
			mode = { "n", "x", "o" },
			desc = "Next comment",
		},
		{
			"[/",
			function()
				require("nvim-treesitter-textobjects.move").goto_previous_start("@comment.outer", "textobjects")
			end,
			mode = { "n", "x", "o" },
			desc = "Previous comment",
		},
		{
			"]z",
			function()
				require("nvim-treesitter-textobjects.move").goto_next_start("@fold", "folds")
			end,
			mode = { "n", "x", "o" },
			desc = "Next fold start",
		},
		{
			"[z",
			function()
				require("nvim-treesitter-textobjects.move").goto_previous_start("@fold", "folds")
			end,
			mode = { "n", "x", "o" },
			desc = "Previous fold start",
		},

		-- Movements (end)
		{
			"]F",
			function()
				require("nvim-treesitter-textobjects.move").goto_next_end("@call.outer", "textobjects")
			end,
			mode = { "n", "x", "o" },
			desc = "Next function call end",
		},
		{
			"[F",
			function()
				require("nvim-treesitter-textobjects.move").goto_previous_end("@call.outer", "textobjects")
			end,
			mode = { "n", "x", "o" },
			desc = "Previous function call end",
		},
		{
			"]M",
			function()
				require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects")
			end,
			mode = { "n", "x", "o" },
			desc = "Next method end",
		},
		{
			"[M",
			function()
				require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
			end,
			mode = { "n", "x", "o" },
			desc = "Previous method end",
		},
		{
			"]C",
			function()
				require("nvim-treesitter-textobjects.move").goto_next_end("@class.outer", "textobjects")
			end,
			mode = { "n", "x", "o" },
			desc = "Next class end",
		},
		{
			"[C",
			function()
				require("nvim-treesitter-textobjects.move").goto_previous_end("@class.outer", "textobjects")
			end,
			mode = { "n", "x", "o" },
			desc = "Previous class end",
		},
		{
			"]A",
			function()
				require("nvim-treesitter-textobjects.move").goto_next_end("@attribute.outer", "textobjects")
			end,
			mode = { "n", "x", "o" },
			desc = "Next attribute end",
		},
		{
			"[A",
			function()
				require("nvim-treesitter-textobjects.move").goto_previous_end("@attribute.outer", "textobjects")
			end,
			mode = { "n", "x", "o" },
			desc = "Previous attribute end",
		},
		{
			"]R",
			function()
				require("nvim-treesitter-textobjects.move").goto_next_end("@argument.outer", "textobjects")
			end,
			mode = { "n", "x", "o" },
			desc = "Next pa[r]ameter/a[r]gument end",
		},
		{
			"[R",
			function()
				require("nvim-treesitter-textobjects.move").goto_previous_end("@argument.outer", "textobjects")
			end,
			mode = { "n", "x", "o" },
			desc = "Previous pa[r]ameter/a[r]gument end",
		},
		{
			"]Z",
			function()
				require("nvim-treesitter-textobjects.move").goto_next_end("@fold", "folds")
			end,
			mode = { "n", "x", "o" },
			desc = "Next fold end",
		},
		{
			"[Z",
			function()
				require("nvim-treesitter-textobjects.move").goto_previous_end("@fold", "folds")
			end,
			mode = { "n", "x", "o" },
			desc = "Previous fold end",
		},
	},
}
