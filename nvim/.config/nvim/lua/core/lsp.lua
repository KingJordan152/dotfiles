-- The following options are only applicable if an LSP has been attached.
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
	callback = function()
		local floating_window = {
			max_width = 100,
			max_height = 25,
		}

		-- Neovim creates keymaps for most LSP actions automatically (see https://neovim.io/doc/user/lsp.html#_global-defaults), but these aren't.
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to Declaration" })

		-- Customize the LSP hover window
		local default_hover = vim.lsp.buf.hover
		---@diagnostic disable-next-line: duplicate-set-field
		vim.lsp.buf.hover = function()
			return default_hover({
				max_width = floating_window.max_width,
				max_height = floating_window.max_height,
			})
		end

		-- Customize how diagnostics work
		vim.diagnostic.config({
			severity_sort = true,
			float = { source = "if_many", max_width = floating_window.max_width },
			underline = { severity = vim.diagnostic.severity.ERROR },
			signs = vim.g.have_nerd_font and {
				text = {
					[vim.diagnostic.severity.ERROR] = " ",
					[vim.diagnostic.severity.WARN] = " ",
					[vim.diagnostic.severity.INFO] = " ",
					[vim.diagnostic.severity.HINT] = " ",
				},
			} or {},
			virtual_text = {
				source = "if_many",
				spacing = 2,
				format = function(diagnostic)
					local diagnostic_message = {
						[vim.diagnostic.severity.ERROR] = diagnostic.message,
						[vim.diagnostic.severity.WARN] = diagnostic.message,
						[vim.diagnostic.severity.INFO] = diagnostic.message,
						[vim.diagnostic.severity.HINT] = diagnostic.message,
					}
					return diagnostic_message[diagnostic.severity]
				end,
			},
		})
	end,
})

-- Configurations for specific LSPs

local cssls_capabilities = vim.lsp.protocol.make_client_capabilities()
cssls_capabilities.textDocument.hover.contentFormat = { "plaintext" }
cssls_capabilities.textDocument.hover.dynamicRegistration = true

vim.lsp.config.cssls = {
	capabilities = cssls_capabilities, -- Remove hover window formatting because it doesn't render properly.
}

vim.lsp.config.cssmodules_ls = {
	init_options = {
		camelCase = false,
	},
}

local nvm_lib_dir = vim.fn.expand("$NVM_BIN/../lib")
local vue_language_server_path = vim.fn.expand("$MASON/packages")
	.. "/vue-language-server"
	.. "/node_modules/@vue/language-server"

vim.lsp.config.ts_ls = {
	init_options = {
		plugins = {
			{
				name = "@styled/typescript-styled-plugin",
				-- TODO: Add check for NVM
				location = nvm_lib_dir,
			},
			{
				name = "typescript-svelte-plugin",
				location = nvm_lib_dir,
			},
			{
				name = "@vue/typescript-plugin",
				location = vue_language_server_path,
				languages = { "vue" },
				configNamespace = "typescript",
			},
		},
	},
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"vue",
	},
	-- Prevents `ts_ls` from running within Deno projects.
	root_dir = function(bufnr, on_dir)
		local project_root = vim.fs.root(bufnr, {
			"package.json",
			"tsconfig.json",
			"package-lock.json",
			"yarn.lock",
			"pnpm-lock.yaml",
			"bun.lockb",
			"bun.lock",
			"jsconfig.json",
		})

		if project_root ~= nil then
			on_dir(project_root)
		end
	end,
	settings = {
		-- Ideally, you should use either Prettier or Stylistic ESLint for formatting instead.
		format = { enable = false },
	},
}

vim.lsp.config.denols = {
	root_markers = { "deno.json", "deno.jsonc" },
	workspace_required = true, -- Prevents `denols` from running inside Node/Bun projects.
	on_attach = function()
		-- Needed to appropriately highlight codefences returned from `denols`.
		vim.g.markdown_fenced_languages = {
			"ts=typescript",
		}
	end,
}

local base_on_attach = vim.lsp.config.eslint.on_attach
vim.lsp.config.eslint = {
	on_attach = function(client, bufnr)
		if not base_on_attach then
			return
		end

		base_on_attach(client, bufnr)
		vim.api.nvim_create_autocmd("BufWritePre", {
			desc = "Automatically fix all fixable ESLint errors on save",
			buffer = bufnr,
			callback = function()
				local is_formatting_disabled = vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat

				if not is_formatting_disabled then
					-- Make a protected call to prevent any errors from obstructing the current buffer.
					local ok, _ = pcall(function()
						vim.cmd("LspEslintFixAll")
					end)

					if not ok then
						vim.api.nvim_echo(
							{ { 'Unable to auto-fix errors in this buffer with "LspEslintFixAll"', "Removed" } },
							true,
							{}
						)
					end
				end
			end,
		})
	end,
}

vim.lsp.config.jsonls = {
	settings = {
		json = {
			schemas = require("schemastore").json.schemas(),
			validate = { enable = true },
		},
	},
}

vim.lsp.config.yamlls = {
	settings = {
		yaml = {
			schemaStore = {
				-- Built-in schemaStore support must be disabled if `SchemaStore` plugin is to be used.
				enable = false,
				-- Avoid TypeError: Cannot read properties of undefined (reading 'length')
				url = "",
			},
			schemas = require("schemastore").yaml.schemas(),
		},
	},
}
