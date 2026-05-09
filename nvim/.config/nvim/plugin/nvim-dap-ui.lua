vim.pack.add({
	-- Dependencies
	"https://codeberg.org/mfussenegger/nvim-dap",
	"https://github.com/nvim-neotest/nvim-nio",

	"https://github.com/rcarriga/nvim-dap-ui",
})

local dap, dapui = require("dap"), require("dapui")

dapui.setup()

-- Automatically open/close `dap-ui` based on debugger statuses
dap.listeners.before.attach.dapui_config = function()
	dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
	dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
	dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	dapui.close()
end
