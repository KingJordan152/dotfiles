vim.pack.add({ "https://codeberg.org/mfussenegger/nvim-dap" })

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

---Configures common VS Code adapters from a given `launch.json` file to use correlating Neovim adapters.
---@param callback fun(adapter: dap.Adapter)
---@param config dap.Configuration
local function js_debug_adapter_for_vscode(callback, config)
	local pwa_name = "pwa-" .. config.type
	local pwa_adapter = require("dap").adapters[pwa_name]

	-- Intercept the user's config and change the `type` to match the `pwa_adapter`'s name.
	config.type = pwa_name

	-- Perform type narrowing to avoid error (either condition has the same outcome).
	if type(pwa_adapter) == "function" then
		pwa_adapter(callback, config)
	else
		callback(pwa_adapter)
	end
end

local dap = require("dap")
local dap_utils = require("dap.utils")
local has_mac = vim.fn.has("mac") == 1
local mason_package_path = vim.fn.stdpath("data") .. "/mason/packages"
local js_filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" }

local js_debug_adapter = {
	type = "server",
	host = "localhost",
	port = "${port}",
	executable = {
		command = "node",
		args = { mason_package_path .. "/js-debug-adapter/js-debug/src/dapDebugServer.js", "${port}" },
	},
}

dap.adapters = {
	["pwa-node"] = js_debug_adapter,
	["pwa-chrome"] = js_debug_adapter,
	["node"] = js_debug_adapter_for_vscode,
	["chrome"] = js_debug_adapter_for_vscode,
	["codelldb"] = {
		type = "executable",
		command = mason_package_path .. "/codelldb/codelldb",
	},
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
		{
			type = "pwa-node",
			request = "launch",
			name = "Launch file (Deno)",
			runtimeExecutable = "deno",
			runtimeArgs = {
				"run",
				"--inspect-wait",
				"--allow-all",
			},
			program = "${file}",
			cwd = "${workspaceFolder}",
			attachSimplePort = 9229,
		},
	}
end

dap.configurations.cpp = {
	{
		name = "Launch file",
		type = "codelldb",
		request = "launch",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
	},
}
dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp
dap.configurations.zig = dap.configurations.cpp

dap.configurations.java = {
	{
		type = "java",
		request = "attach",
		name = "Debug (Attach) - Remote",
		hostName = "127.0.0.1",
		port = 5005,
	},
}

-- Custom icon definitions
vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "Error" })
vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "Error" })
vim.fn.sign_define("DapLogPoint", { text = "", texthl = "Error" })
vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "Error" })
vim.fn.sign_define("DapStopped", { text = "", texthl = "DapUIStop", linehl = "DapStoppedLine" })

-- VS Code-inspired Keymaps
vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debugger: Continue" })
vim.keymap.set("n", "<F53>", dap.restart, { desc = "Debugger: Restart session" }) -- <F53> = <M-F5> (<C-S-F5>) doesn't work in Ghostty
vim.keymap.set("n", "<F17>", dap.terminate, { desc = "Debugger: Quit/Terminate session" }) -- <F17> = <S-F5>
vim.keymap.set("n", "<F9>", dap.toggle_breakpoint, { desc = "Debugger: Toggle breakpoint" })
vim.keymap.set("n", "<F21>", toggle_logpoint, { desc = "Debugger: Toggle logpoint" }) -- <F21> = <S-F9>
vim.keymap.set("n", "<F57>", toggle_conditional_breakpoint, { desc = "Debugger: Toggle conditional breakpoint" }) -- <F57> = <M-F9>
vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Debugger: Step over" })
vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Debugger: Step into" })
vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Debugger: Step out" })

-- General Keymaps
vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue" })
vim.keymap.set("n", "<leader>dr", dap.restart, { desc = "Restart session" })
vim.keymap.set("n", "<leader>dq", dap.terminate, { desc = "Quit/Terminate session" })
vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
vim.keymap.set("n", "<leader>dB", toggle_logpoint, { desc = "Toggle logpoint" })
vim.keymap.set("n", "<leader>d?", toggle_conditional_breakpoint, { desc = "Toggle conditional breakpoint" })
vim.keymap.set("n", "<leader>dl", dap.step_over, { desc = "Step over" })
vim.keymap.set("n", "<leader>dh", dap.step_back, { desc = "Step back" })
vim.keymap.set("n", "<leader>dj", dap.step_into, { desc = "Step into" })
vim.keymap.set("n", "<leader>dk", dap.step_out, { desc = "Step out" })
