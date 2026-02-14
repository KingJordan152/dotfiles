return {
	"mfussenegger/nvim-dap-python",
	ft = "python",
	config = function()
		local mason_package_path = vim.fn.stdpath("data") .. "/mason/packages"
		local dap_python = require("dap-python")

		dap_python.setup(mason_package_path .. "/debugpy/debugpy-adapter")

		vim.keymap.set("v", "<leader>ds", dap_python.debug_selection, { desc = "Python - Debug selection" })
		vim.keymap.set("n", "<leader>dC", dap_python.test_class, { desc = "Python - Run test class above cursor" })
		vim.keymap.set("n", "<leader>dm", dap_python.test_method, { desc = "Python - Run test method above cursor" })
	end,
}
