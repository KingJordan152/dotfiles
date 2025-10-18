return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
	},
	event = "VeryLazy",
	config = function()
		local dap = require("dap")
		local dap_utils = require("dap.utils")
		local mason_package_path = vim.fn.stdpath("data") .. "/mason/packages"
		local js_filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" }

		dap.adapters = {
			["pwa-node"] = {
				type = "server",
				host = "localhost",
				port = "${port}",
				executable = {
					command = "node",
					args = { mason_package_path .. "/js-debug-adapter/js-debug/src/dapDebugServer.js", "${port}" },
				},
			},
			-- Commonly used in VS Code `launch.json` configurations
			["node"] = function(callback, config)
				-- Use `pwa-node` adapter for `node`; they're exactly the same.
				local pwa_node_adapter = dap.adapters["pwa-node"]

				-- DAP config must use "pwa-node", otherwise the debugger will always fail.
				if config.type == "node" then
					config.type = "pwa-node"
				end

				-- Perform type narrowing to avoid error (else-condition should always run).
				if type(pwa_node_adapter) == "function" then
					pwa_node_adapter(callback, config)
				else
					callback(pwa_node_adapter)
				end
			end,
		}

		for _, filetype in ipairs(js_filetypes) do
			dap.configurations[filetype] = {
				{
					type = "pwa-node",
					request = "launch",
					name = "Launch file",
					program = "${file}",
					cwd = "${workspaceFolder}",
					sourceMaps = true,
				},
				{
					type = "pwa-node",
					request = "attach",
					name = "Attach",
					processId = dap_utils.pick_process,
					cwd = "${workspaceFolder}",
					sourceMaps = true,
				},
			}
		end

		vim.keymap.set("n", "<F5>", function()
			dap.continue()
		end, { desc = "Debugger: Continue" })
		vim.keymap.set("n", "<F10>", function()
			dap.step_over()
		end, { desc = "Debugger: Step Over" })
		vim.keymap.set("n", "<F11>", function()
			dap.step_into()
		end, { desc = "Debugger: Step Into" })
		vim.keymap.set("n", "<F12>", function()
			dap.step_out()
		end, { desc = "Debugger: Step Out" })
		vim.keymap.set("n", "<Leader>b", function()
			dap.toggle_breakpoint()
		end, { desc = "Debugger: Toggle Breakpoint" })
		vim.keymap.set("n", "<Leader>lp", function()
			dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
		end, { desc = "Debugger: Add Log Point" })
	end,
}
