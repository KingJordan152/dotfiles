vim.api.nvim_create_autocmd("FileType", {
  pattern = { "java" },
  group = vim.api.nvim_create_augroup("nvim-jdtls", {}),
  once = true,
  callback = function()
    vim.pack.add({
      -- Dependencies
      "https://codeberg.org/mfussenegger/nvim-dap",

      "https://codeberg.org/mfussenegger/nvim-jdtls",
    })

    local jdtls = require("jdtls")

    -- Additional LSP actions
    vim.keymap.set("n", "grs", jdtls.super_implementation, { desc = "Java: Jump to method super implementation" })
    vim.keymap.set("n", "grv", jdtls.extract_variable, { desc = "Java: Extract variable" })
    vim.keymap.set("n", "grC", jdtls.extract_constant, { desc = "Java: Extract constant" })
    vim.keymap.set("n", "grm", jdtls.extract_method, { desc = "Java: Extract method" })
    vim.keymap.set("v", "grv", function() jdtls.extract_variable({ visual = true }) end, { desc = "Java: Extract Variable" })
    vim.keymap.set("v", "grC", function() jdtls.extract_constant({ visual = true }) end, { desc = "Java: Extract constant" })
    vim.keymap.set("v", "grm", function() jdtls.extract_method({ visual = true }) end, { desc = "Java: Extract method" })

    -- Debugging
    vim.keymap.set("n", "<leader>dC", jdtls.test_class, { desc = "Java - Run test class above cursor" })
    vim.keymap.set("n", "<leader>dm", jdtls.test_nearest_method, { desc = "Java - Run test method above cursor" })
  end,
})
