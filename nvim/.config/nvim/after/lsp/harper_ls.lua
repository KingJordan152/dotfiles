---@type vim.lsp.Config
return {
	filetypes = {
		"markdown",
		"text",
		"gitcommit",
		"typst",
	},
	settings = {
		["harper-ls"] = {
			diagnosticSeverity = "error",
			linters = {
				ToDoHyphen = false, -- Conflicts with `todo-comments`
				SentenceCapitalization = false, -- Obvious and rarely happens

				-- Undo expansions that conflict with expected technical jargon
				ExpandArgument = false,
				ExpandMemoryShorthands = false,
			},
		},
	},
	on_attach = function(client)
		vim.diagnostic.config({
			virtual_text = false,
			update_in_insert = true,
		}, vim.lsp.diagnostic.get_namespace(client.id))
	end,
}
