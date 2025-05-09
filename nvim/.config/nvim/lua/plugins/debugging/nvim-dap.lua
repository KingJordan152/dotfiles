return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "leoluz/nvim-dap-go",
  },

  config = function()
    local dap = require("dap")

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
