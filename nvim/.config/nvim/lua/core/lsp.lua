-- The following options are only applicable if an LSP has been attached.
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
	callback = function()
		-- Neovim creates keymaps for most LSP actions automatically (see https://neovim.io/doc/user/lsp.html#_global-defaults), but these aren't.
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to Declaration" })

		-- Customize the LSP hover window
		local default_hover = vim.lsp.buf.hover
		---@diagnostic disable-next-line: duplicate-set-field
		vim.lsp.buf.hover = function()
			return default_hover({
				border = "rounded",
				max_height = 25,
				max_width = 100,
			})
		end

		-- Customize how diagnostics work
		vim.diagnostic.config({
			severity_sort = true,
			float = { border = "rounded", source = "if_many" },
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

vim.lsp.config.ts_ls = {
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
					vim.cmd("LspEslintFixAll")
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
				-- You must disable built-in schemaStore support if you want to use
				-- this plugin and its advanced options like `ignore`.
				enable = false,
				-- Avoid TypeError: Cannot read properties of undefined (reading 'length')
				url = "",
			},
			schemas = require("schemastore").yaml.schemas(),
		},
	},
}
