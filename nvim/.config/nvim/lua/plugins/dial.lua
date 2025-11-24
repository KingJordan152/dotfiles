return {
	"monaqa/dial.nvim",
	opts = function()
		local augend = require("dial.augend")

		local logical_symbol_operators = augend.constant.new({
			elements = { "&&", "||" },
			word = false,
			cyclic = true,
		})

		local logical_word_operators = augend.constant.new({
			elements = { "and", "or" },
			word = true,
			cyclic = true,
		})

		local ordinal_numbers = augend.constant.new({
			elements = {
				"first",
				"second",
				"third",
				"fourth",
				"fifth",
				"sixth",
				"seventh",
				"eighth",
				"ninth",
				"tenth",
			},
			word = false,
			cyclic = true,
		})

		local months = augend.constant.new({
			elements = {
				"January",
				"February",
				"March",
				"April",
				"May",
				"June",
				"July",
				"August",
				"September",
				"October",
				"November",
				"December",
			},
			word = true,
			cyclic = true,
		})

		local javascript_filetypes = {
			augend.constant.new({ elements = { "let", "const" } }),
		}

		return {
			default = {
				augend.integer.alias.decimal, -- (0, 1, 2, 3, ...)
				augend.integer.alias.decimal_int, -- (-2, -1, 0, 1, 2, ...)
				augend.integer.alias.hex, -- Hex numbers  (0x01, 0x1a1f, etc.)
				augend.date.alias["%Y/%m/%d"], -- (2022/02/19, ...)
				augend.date.alias["%d/%m/%Y"], -- (02/19/2022, ...)
				augend.date.alias["%d/%m/%y"], -- (02/19/22, ...)
				augend.constant.alias.bool, -- (true <-> false)
				augend.constant.alias.en_weekday_full, -- (Monday, Tuesday, Wednesday, ...)
				augend.constant.alias.en_weekday, -- (Mon, Tue, ...)
				ordinal_numbers,
				months,
				logical_symbol_operators,
			},
			filetypes = {
				vue = {
					augend.constant.new({ elements = { "let", "const" } }),
					augend.hexcolor.new({ case = "lower" }),
					augend.hexcolor.new({ case = "upper" }),
				},
				javascript = javascript_filetypes,
				typescript = javascript_filetypes,
				javascriptreact = javascript_filetypes,
				typescriptreact = javascript_filetypes,
				css = {
					augend.hexcolor.new({
						case = "lower",
					}),
					augend.hexcolor.new({
						case = "upper",
					}),
				},
				markdown = {
					augend.misc.alias.markdown_header,
				},
				json = {
					augend.semver.alias.semver,
				},
				lua = {
					logical_word_operators,
				},
				python = {
					logical_word_operators,
					augend.constant.alias.Bool,
				},
			},
		}
	end,
	config = function(_, opts)
		local augends = require("dial.config").augends

		-- Copy defaults to each group.
		for name, group in pairs(opts.filetypes) do
			if name ~= "default" then
				vim.list_extend(group, opts.default)
			end
		end

		augends:register_group(opts.default)
		augends:on_filetype(opts.filetypes)
	end,
	keys = {
		{
			"<C-a>",
			function()
				require("dial.map").manipulate("increment", "normal")
			end,
			desc = "Increment",
		},
		{
			"<C-x>",
			function()
				require("dial.map").manipulate("decrement", "normal")
			end,
			desc = "Decrement",
		},
		{
			"g<C-a>",
			function()
				require("dial.map").manipulate("increment", "gnormal")
			end,
			desc = "Increment",
		},
		{
			"g<C-x>",
			function()
				require("dial.map").manipulate("decrement", "gnormal")
			end,
			desc = "Decrement",
		},
		{
			"<C-a>",
			function()
				require("dial.map").manipulate("increment", "visual")
			end,
			mode = "x",
			desc = "Increment",
		},
		{
			"<C-x>",
			function()
				require("dial.map").manipulate("decrement", "visual")
			end,
			mode = "x",
			desc = "Decrement",
		},
		{
			"g<C-a>",
			function()
				require("dial.map").manipulate("increment", "gvisual")
			end,
			mode = "x",
			desc = "Increment",
		},
		{
			"g<C-x>",
			function()
				require("dial.map").manipulate("decrement", "gvisual")
			end,
			mode = "x",
			desc = "Decrement",
		},
	},
}
