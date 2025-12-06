return {
	"saghen/blink.cmp",
	dependencies = { "L3MON4D3/LuaSnip" },
	version = "1.*",
	event = { "InsertEnter", "CmdlineEnter", "TermEnter" },

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		-- Controls which filetypes `blink.cmp` is enabled for
		enabled = function()
			return not vim.tbl_contains({ "oil" }, vim.bo.filetype)
		end,

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
			["<C-t>"] = {
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
			["<C-d>"] = { "snippet_backward", "fallback" },
		},

		appearance = {
			-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
			-- Adjusts spacing to ensure icons are aligned
			nerd_font_variant = "normal",
		},

		completion = {
			menu = {
				max_height = 12,
				min_width = 25,
			},

			list = {
				selection = {
					-- Highlight first option.
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

		cmdline = {
			completion = {
				menu = {
					auto_show = true, -- Not default `true` for `cmdline`.
				},
				list = {
					selection = {
						-- Highlight first option.
						preselect = true,
						-- Don't auto insert on selection.
						auto_insert = false,
					},
				},
			},
			keymap = {
				preset = "inherit",

				-- Overrides
				["<CR>"] = false, -- Prevents commands that are purposely entered from being replaced by the first completion item.
				["<C-n>"] = { "select_next", "fallback" }, -- Use "fallback" so that you can still cycle between previous commands when completion menu isn't open.
				["<C-p>"] = { "select_prev", "fallback" }, -- ""
			},
		},

		-- Can be toggled with `<C-k>`.
		signature = {
			enabled = true,
			trigger = {
				enabled = false, -- Prevents signature window from automatically showing.
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
				cmdline = {
					min_keyword_length = function(ctx)
						-- When typing a command, only show when the keyword is 3 characters or longer
						if ctx.mode == "cmdline" and string.find(ctx.line, " ") == nil then
							return 3
						end

						return 0
					end,
				},
			},
		},

		fuzzy = {
			implementation = "prefer_rust_with_warning",
			-- sorts = {
			-- 	-- Deprioritize Emmet suggestions when other suggestions are available.
			-- 	function(a, b)
			-- 		if (a.client_name == nil or b.client_name == nil) or (a.client_name == b.client_name) then
			-- 			return
			-- 		end
			-- 		return b.client_name == "emmet_language_server"
			-- 	end,
			--
			-- 	-- Default sorts
			-- 	"score",
			-- 	"sort_text",
			-- },
		},
	},
	opts_extend = { "sources.default" },
}
