return {
	-- Prevents `denols` from running inside Node/Bun projects.
	root_markers = { "deno.json", "deno.jsonc" },
	workspace_required = true,

	-- Needed to appropriately highlight codefences returned from `denols`.
	on_attach = function()
		vim.g.markdown_fenced_languages = {
			"ts=typescript",
		}
	end,
}
