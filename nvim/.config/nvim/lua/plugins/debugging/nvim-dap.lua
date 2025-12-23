---Prompts the user for a message to use for a logpoint breakpoint.
local function toggle_logpoint()
	return vim.ui.input({ prompt = "Logpoint Message (expressions within {} are interpolated)" }, function(input)
		if input == nil then
			return
		end

		require("dap").set_breakpoint(nil, nil, input)
	end)
end

---Prompts the user for an expression to use for a conditional breakpoint.
local function toggle_conditional_breakpoint()
	return vim.ui.input({ prompt = "Break when the following expression evaluates to true" }, function(input)
		if input == nil then
			return
		end

		require("dap").set_breakpoint(input, nil, nil)
	end)
end

return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
	},
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
		vim.fn.sign_define("DapStopped", { text = "", texthl = "DapUIDecoration" })

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
	end,
	keys = {
		-- VS Code-flavored Keymaps
		{
			"<F5>",
			function()
				require("dap").continue()
			end,
			desc = "Debugger: Continue",
		},
		{
			"<F53>", -- <F53> = <M-F5> (<C-S-F5>) doesn't work in Ghostty
			function()
				require("dap").restart()
			end,
			desc = "Debugger: Restart session",
		},
		{
			"<F17>", -- <F17> = <S-F5>
			function()
				require("dap").terminate()
			end,
			desc = "Debugger: Quit/Terminate session",
		},
		{
			"<F9>",
			function()
				require("dap").toggle_breakpoint()
			end,
			desc = "Debugger: Toggle breakpoint",
		},
		{
			"<F21>", -- <F21> = <S-F9>
			toggle_logpoint,
			desc = "Debugger: Toggle logpoint",
		},
		{
			"<F57>", -- <F57> = <M-F9>
			toggle_conditional_breakpoint,
			desc = "Debugger: Toggle conditional breakpoint",
		},
		{
			"<F10>",
			function()
				require("dap").step_over()
			end,
			desc = "Debugger: Step over",
		},
		{
			"<F11>",
			function()
				require("dap").step_into()
			end,
			desc = "Debugger: Step into",
		},
		{
			"<F12>",
			function()
				require("dap").step_out()
			end,
			desc = "Debugger: Step out",
		},

		-- Neovim-flavored Keymaps
		{
			"<leader>dc",
			function()
				require("dap").continue()
			end,
			desc = "Continue",
		},
		{
			"<leader>dr",
			function()
				require("dap").restart()
			end,
			desc = "Restart session",
		},
		{
			"<leader>dq",
			function()
				require("dap").terminate()
			end,
			desc = "Quit/Terminate session",
		},
		{
			"<leader>db",
			function()
				require("dap").toggle_breakpoint()
			end,
			desc = "Toggle breakpoint",
		},
		{
			"<leader>dB",
			toggle_logpoint,
			desc = "Toggle logpoint",
		},
		{
			"<leader>d?",
			toggle_conditional_breakpoint,
			desc = "Toggle conditional breakpoint",
		},
		{
			"<leader>dl",
			function()
				require("dap").step_over()
			end,
			desc = "Step over",
		},
		{
			"<leader>dh",
			function()
				require("dap").step_back()
			end,
			desc = "Step back",
		},
		{
			"<leader>dj",
			function()
				require("dap").step_into()
			end,
			desc = "Step into",
		},
		{
			"<leader>dk",
			function()
				require("dap").step_out()
			end,
			desc = "Step out",
		},
	},
}
