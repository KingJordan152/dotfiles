vim.api.nvim_create_autocmd("FileType", {
	pattern = { "python" },
	callback = function()
		vim.pack.add({
			-- Dependencies
			"https://codeberg.org/mfussenegger/nvim-dap",

			"https://codeberg.org/mfussenegger/nvim-dap-python",
		})

		local mason_package_path = vim.fn.expand("$MASON/packages")
		local dap_python = require("dap-python")

		dap_python.setup(mason_package_path .. "/debugpy/debugpy-adapter")

		vim.keymap.set("v", "<leader>ds", dap_python.debug_selection, { desc = "Python - Debug selection" })
		vim.keymap.set("n", "<leader>dC", dap_python.test_class, { desc = "Python - Run test class above cursor" })
		vim.keymap.set("n", "<leader>dm", dap_python.test_method, { desc = "Python - Run test method above cursor" })
	end,
})
