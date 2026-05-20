local utils = require("utils")
local lsp_config_group = vim.api.nvim_create_augroup("lsp_config", {})

vim.api.nvim_create_autocmd("LspAttach", {
	desc = "Applies various keymaps and default behaviors for LSPs",
	group = lsp_config_group,
	callback = function(event)
		local client = assert(vim.lsp.get_client_by_id(event.data.client_id))
		local buf = event.buf

		-- Enable certain capabilities by default.
		vim.lsp.codelens.enable(true)

		-- Neovim creates keymaps for most LSP actions automatically (see https://neovim.io/doc/user/lsp.html#_global-defaults), but these aren't.
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition", buf = buf })
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to Declaration", buf = buf })
		vim.keymap.set("n", "grq", vim.diagnostic.setloclist, { desc = "Add buffer diagnostics to location list" })
		vim.keymap.set("n", "grQ", function()
			-- Prompt the user for their desired severity level.
			vim.ui.select(vim.list_extend({ "ALL" }, vim.diagnostic.severity), {
				prompt = "Select severity level",
			}, function(choice)
				if choice == nil then
					return
				end

				vim.diagnostic.setqflist(choice ~= "ALL" and {
					severity = choice,
				} or {})
			end)
		end, { desc = "Add all diagnostics to quickfix list" })

		-- Although this keymap is automatically set by Neovim, it must be redefined in order
		-- to consistently overwrite the `keywordprg` keymap on session restoration.
		-- (see https://github.com/rmagatti/auto-session/issues/512#issuecomment-3999927434)
		vim.keymap.set("n", "K", function()
			vim.lsp.buf.hover({
				max_width = utils.floating_windows.max_width,
				max_height = utils.floating_windows.max_height,
			})
		end, { desc = "Hover Documentation", buf = buf })

		if client:supports_method("textDocument/codeAction") then
			local codeActionProvider = client.server_capabilities.codeActionProvider

			-- Code Action providers may not return the `codeActionKinds` that they support.
			-- This is typically true for in-process LSPs, like `vim-pack`.
			-- In this case, default to the built-in `gra` code action keymap to ensure any available
			-- code actions still shown.
			if
				type(codeActionProvider) == "table"
				and client.server_capabilities.codeActionProvider["codeActionKinds"] ~= nil
			then
				-- Use to generate actions that are relevant to where the cursor is currently positioned.
				vim.keymap.set({ "n", "x" }, "gra", function()
					vim.lsp.buf.code_action({
						---@diagnostic disable-next-line: missing-fields
						context = {
							only = {
								"refactor", -- "Move to...", "Extract to...", etc.
								"quickfix", -- Disable error, Fix issue, etc.
							},
						},
					})
				end, { desc = "LSP Code Action", buf = buf })

				-- Use to generate "source" actions that are relevant anywhere in the current file.
				vim.keymap.set({ "n", "x" }, "grA", function()
					vim.lsp.buf.code_action({
						context = {
							only = {
								"source", -- Sort imports, fix all issues, remove unused code, etc.
							},
							diagnostics = {},
						},
					})
				end, { desc = "LSP Source Action", buf = buf })
			end
		end

		if client:supports_method("textDocument/documentColor") then
			vim.keymap.set(
				{ "n", "x" },
				"grc",
				vim.lsp.document_color.color_presentation,
				{ desc = "Select a different color presentation", buf = buf }
			)
		end

		if client:supports_method("textDocument/inlayHint") then
			vim.keymap.set("n", "<leader>th", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buf }))
			end, { desc = "Toggle Inlay Hints", buf = buf })
		end

		if client:supports_method("textDocument/codeLens") then
			vim.keymap.set("n", "<leader>tx", function()
				vim.lsp.codelens.enable(not vim.lsp.codelens.is_enabled({ bufnr = buf }))
			end, { desc = "Toggle CodeLens", buf = buf })
		end

		if client.name == "eslint" or client.name == "oxlint" then
			vim.keymap.set("n", "<leader>lf", function()
				local Name = client.name:gsub("^%l", string.upper)
				vim.cmd("Lsp" .. Name .. "FixAll")
			end, { desc = "Fix all fixable issues", buf = buf })
		end

		vim.api.nvim_create_autocmd("LspProgress", {
			desc = "Display LSP progress messages",
			nested = true,
			group = lsp_config_group,
			buffer = buf,
			callback = function(ev)
				local value = ev.data.params.value
				local status = value.kind ~= "end" and "running" or "success"
				local message = (not value.message and status ~= "success") and status or value.message or "done"

				-- Truncate messages if they're too long (e.g., Rust Analyzer)
				if #message > 40 then
					message = message:sub(1, 37) .. "..."
				end

				vim.api.nvim_echo({ { message } }, false, {
					id = "lsp." .. ev.data.client_id,
					kind = "progress",
					source = "vim.lsp",
					title = value.title,
					status = status,
					percent = value.percentage,
				})
			end,
		})
	end,
})
