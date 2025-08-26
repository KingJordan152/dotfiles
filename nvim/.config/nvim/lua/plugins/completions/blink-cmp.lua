return {
	"saghen/blink.cmp",
	dependencies = { "L3MON4D3/LuaSnip" },
	version = "1.*",

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		-- All presets have the following mappings:
		-- C-space: Open menu or open docs if already open
		-- C-n/C-p or Up/Down: Select next/previous item
		-- C-e: Hide menu
		-- C-k: Toggle signature help (if signature.enabled = true)
		--
		-- See :h blink-cmp-config-keymap for defining your own keymap
		keymap = {
			preset = "default",

			-- Overrides
			["<CR>"] = { "select_and_accept", "fallback" }, -- Enable selection via "Enter"
			["<Tab>"] = { "select_and_accept", "fallback" }, -- Enable selection via "Tab" (remove snippet forward jump feature)
			["<S-Tab>"] = false, -- Remove snippet backward jump feature

			-- New snippet commands
			["<C-y>"] = {
				function(cmp)
					if cmp.snippet_active() then
						return cmp.accept()
					else
						return cmp.select_and_accept()
					end
				end,
				"snippet_forward",
				"fallback",
			},
			["<C-S-Y>"] = { "snippet_backward", "fallback" },
		},

		appearance = {
			-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
			-- Adjusts spacing to ensure icons are aligned
			nerd_font_variant = "normal",
		},

		completion = {
			menu = {
				border = "rounded",
				max_height = 12,
				min_width = 25,
			},

			list = {
				selection = {
					-- Highlight first option
					preselect = true,
					-- Don't auto insert on selection.
					auto_insert = false,
				},
			},

			documentation = {
				auto_show = true,
				treesitter_highlighting = true,
				auto_show_delay_ms = 0,
				window = {
					border = "rounded",
					max_width = 50,
					max_height = 25,
				},
			},

			accept = {
				auto_brackets = {
					-- Disabling because it doesn't always work and VS Code doesn't have it enabled by default.
					enabled = false,
				},
			},
		},

		snippets = {
			preset = "luasnip",
		},

		sources = {
			default = { "lazydev", "lsp", "path", "snippets" },
			providers = {
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					-- Make lazydev completions top priority (see `:h blink.cmp`)
					score_offset = 100,
				},
			},
		},

		-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
		-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
		-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
		--
		-- See the fuzzy documentation for more information
		fuzzy = { implementation = "prefer_rust_with_warning" },
	},
	opts_extend = { "sources.default" },
}
