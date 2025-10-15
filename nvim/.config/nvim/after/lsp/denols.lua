return {
	root_markers = { "deno.json", "deno.jsonc" },
	workspace_required = true, -- Prevents `denols` from running inside Node/Bun projects.
	on_attach = function()
		-- Needed to appropriately highlight codefences returned from `denols`.
		vim.g.markdown_fenced_languages = {
			"ts=typescript",
		}
	end,
}
