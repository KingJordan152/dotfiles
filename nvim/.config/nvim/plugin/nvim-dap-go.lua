vim.api.nvim_create_autocmd("FileType", {
  pattern = { "go", "gomod", "gowork", "gotmpl" },
  group = vim.api.nvim_create_augroup("nvim-dap-go", {}),
  once = true,
  callback = function()
    vim.pack.add({
      -- Dependencies
      "https://codeberg.org/mfussenegger/nvim-dap",

      "https://github.com/leoluz/nvim-dap-go",
    })

    local dap_go = require("dap-go")
    dap_go.setup()

    vim.keymap.set("n", "<leader>dt", dap_go.debug_test, { desc = "Go - Debug method closest to cursor" })
    vim.keymap.set("n", "<leader>dT", dap_go.debug_last_test, { desc = "Go - Debug last test" })
  end,
})
