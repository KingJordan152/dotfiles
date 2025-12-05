return {
	"nvim-treesitter/nvim-treesitter-textobjects",
	branch = "main",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")

		require("nvim-treesitter-textobjects").setup({
			select = {
				lookahead = true,
				selection_modes = {
					["@function.outer"] = "V",
					["@class.outer"] = "V",
				},
			},
			move = {
				set_jumps = true,
			},
		})

		-- Make textobject movments repeatable with ; and ,
		vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
		vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

		-- Ensure `f/t` motions can still be repeated with ; and ,
		vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
		vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
		vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
		vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
	end,
	keys = {
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
			desc = "function call",
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
			desc = "method",
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
			desc = "class",
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
			desc = "attribute",
		},
		{
			"ar",
			function()
				require("nvim-treesitter-textobjects.select").select_textobject("@parameter.outer", "textobjects")
			end,
			mode = { "x", "o" },
			desc = "pa[r]ameter / a[r]gument",
		},
		{
			"ir",
			function()
				require("nvim-treesitter-textobjects.select").select_textobject("@parameter.inner", "textobjects")
			end,
			mode = { "x", "o" },
			desc = "pa[r]ameter / a[r]gument",
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
			desc = "Next pa[r]ameter / a[r]gument start",
		},
		{
			"[r",
			function()
				require("nvim-treesitter-textobjects.move").goto_previous_start("@argument.outer", "textobjects")
			end,
			mode = { "n", "x", "o" },
			desc = "Previous pa[r]ameter / a[r]gument start",
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
			desc = "Next pa[r]ameter / a[r]gument end",
		},
		{
			"[R",
			function()
				require("nvim-treesitter-textobjects.move").goto_previous_end("@argument.outer", "textobjects")
			end,
			mode = { "n", "x", "o" },
			desc = "Previous pa[r]ameter / a[r]gument end",
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
