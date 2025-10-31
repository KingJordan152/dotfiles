return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
	},
	event = "VeryLazy",
	config = function()
		local dap = require("dap")
		local dap_utils = require("dap.utils")
		local has_mac = vim.fn.has("mac") == 1
		local mason_package_path = vim.fn.stdpath("data") .. "/mason/packages"
		local js_filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" }

		-- Define custom icons
		vim.fn.sign_define("DapBreakpoint", { text = "󰄯", texthl = "Error" })
		vim.fn.sign_define("DapBreakpointCondition", { text = "󰍶", texthl = "Error" })
		vim.fn.sign_define("DapLogPoint", { text = "󰜋", texthl = "Error" })
		vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "Error" })

		local js_debug_adapter = {
			type = "server",
			host = "localhost",
			port = "${port}",
			executable = {
				command = "node",
				args = { mason_package_path .. "/js-debug-adapter/js-debug/src/dapDebugServer.js", "${port}" },
			},
		}

		---Configures common VS Code adapters from a given `launch.json` file to use correlating Neovim adapters.
		---@param callback fun(adapter: dap.Adapter)
		---@param config dap.Configuration
		local function js_debug_adapter_for_vscode(callback, config)
			local pwa_name = "pwa-" .. config.type
			local pwa_adapter = dap.adapters[pwa_name]

			-- Intercept the user's config and change the `type` to match the `pwa_adapter`'s name.
			config.type = pwa_name

			-- Perform type narrowing to avoid error (either condition has the same outcome).
			if type(pwa_adapter) == "function" then
				pwa_adapter(callback, config)
			else
				callback(pwa_adapter)
			end
		end

		dap.adapters = {
			["pwa-node"] = js_debug_adapter,
			["pwa-chrome"] = js_debug_adapter,
			["node"] = js_debug_adapter_for_vscode,
			["chrome"] = js_debug_adapter_for_vscode,
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
				{
					type = "pwa-chrome",
					request = "launch",
					name = "Launch Brave",
					url = "http://localhost:5173", -- Assume Vite
					webRoot = "${workspaceFolder}",
					sourceMaps = true,
					runtimeExecutable = has_mac and "/Applications/Brave Browser.app/Contents/MacOS/Brave Browser"
						or "/usr/bin/brave-browser",
					runtimeArgs = {
						"--remote-debugging-port=9222",
						"--user-data-dir=remote-debug-profile",
					},
				},
				{
					type = "pwa-chrome",
					request = "attach",
					name = "Attach to Brave",
					webRoot = "${workspaceFolder}",
					urlFilter = "http://localhost:5173/*", -- Assume Vite
					port = 9222,
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
