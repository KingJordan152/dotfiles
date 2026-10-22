vim.pack.add({ "https://github.com/tronikelis/ts-autotag.nvim" })

require("ts-autotag").setup({
  auto_rename = {
    enabled = true,
  },
})
