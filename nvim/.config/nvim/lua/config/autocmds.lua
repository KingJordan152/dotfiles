local utils = require("core.utils")
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local lsp_config_group = augroup("lsp_config", { clear = true })

autocmd("LspAttach", {
	desc = "Applies various keymaps and settings for LSPs",
	group = lsp_config_group,
	callback = function(event)
		local client = assert(vim.lsp.get_client_by_id(event.data.client_id))
		local buf = event.buf

		-- Enable certain capabilities by default.
		vim.lsp.codelens.enable(true)

		-- Neovim creates keymaps for most LSP actions automatically (see https://neovim.io/doc/user/lsp.html#_global-defaults), but these aren't.
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition", buffer = buf })
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to Declaration", buffer = buf })

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
			end, { desc = "LSP Code Action" })

			-- Use to generate actions that are relevant anywhere in the current file.
			vim.keymap.set({ "n", "x" }, "grs", function()
				vim.lsp.buf.code_action({
					context = {
						only = {
							"source", -- Sort imports, fix all issues, remove unused code, etc.
						},
						diagnostics = {},
					},
				})
			end, { desc = "LSP Source Action" })
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
			vim.keymap.set("n", "<leader>tl", function()
				vim.lsp.codelens.enable(not vim.lsp.codelens.is_enabled({ bufnr = buf }))
			end, { desc = "Toggle CodeLens", buf = buf })
		end

		if client.name == "eslint" or client.name == "oxlint" then
			vim.keymap.set("n", "<leader>lf", function()
				local Name = client.name:gsub("^%l", string.upper)
				vim.cmd("Lsp" .. Name .. "FixAll")
			end, { desc = "Fix all fixable issues", buf = buf })
		end

		autocmd("LspProgress", {
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

local hybrid_line_exclude_files = utils.Set({
	"snacks_dashboard",
	"snacks_explorer",
	"lazy",
	"mason",
	"snacks_picker_list",
	"snacks_terminal",
	"TelescopePrompt",
	"help",
})

local hybrid_line_numbers = augroup("hybrid_line_numbers", { clear = true })

autocmd("InsertEnter", {
	desc = "Disable relative line numbers when entering Insert mode",
	group = hybrid_line_numbers,
	callback = function()
		if not hybrid_line_exclude_files[vim.bo.filetype] then
			vim.o.relativenumber = false
		end
	end,
})

autocmd("InsertLeave", {
	desc = "Enable relative line numbers when leaving Insert mode",
	group = hybrid_line_numbers,
	callback = function()
		if not hybrid_line_exclude_files[vim.bo.filetype] then
			vim.o.relativenumber = true
		end
	end,
})

autocmd("TextYankPost", {
	desc = "Briefly highlight yanked text",
	group = augroup("highlight_yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

autocmd("FileType", {
	desc = "Add unique keymaps to readonly files",
	group = augroup("readonly_keymaps", { clear = true }),
	pattern = "*",
	callback = function(args)
		if vim.bo[args.buf].readonly or not vim.bo[args.buf].modifiable then
			vim.keymap.set("n", "gq", "<cmd>q<cr>", {
				desc = "Quit the current window",
				buffer = true,
			})
		end
	end,
})

autocmd("VimResized", {
	desc = "Automatically resize splits when the terminal's window is resized",
	group = augroup("equalize_splits", { clear = true }),
	callback = function()
		local current_tab = vim.api.nvim_get_current_tabpage()

		vim.cmd("tabdo wincmd =")
		vim.api.nvim_set_current_tabpage(current_tab)
	end,
})
