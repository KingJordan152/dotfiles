return {
	"leoluz/nvim-dap-go",
	ft = "go",
	config = function()
		local dap_go = require("dap-go")
		dap_go.setup()

		vim.keymap.set("n", "<leader>dt", dap_go.debug_test, { desc = "Go - Debug method closest to cursor" })
		vim.keymap.set("n", "<leader>dT", dap_go.debug_last_test, { desc = "Go - Debug last test" })
	end,
}
