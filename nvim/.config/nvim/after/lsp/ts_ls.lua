return {
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
