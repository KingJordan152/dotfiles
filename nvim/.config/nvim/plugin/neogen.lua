vim.pack.add({ "https://github.com/danymat/neogen" })

require("neogen").setup({})

vim.keymap.set("n", "<leader>@", require("neogen").generate, { desc = "Generate annotation" })
