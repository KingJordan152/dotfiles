vim.api.nvim_create_autocmd("FileType", {
  pattern = { "lua" },
  group = vim.api.nvim_create_augroup("lazydev", {}),
  once = true,
  callback = function()
    vim.pack.add({ "https://github.com/folke/lazydev.nvim" })

    require("lazydev").setup({
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } }, -- Load luvit types when the `vim.uv` word is found
        { path = "nvim-lspconfig", words = { "lspconfig" } },
        { path = "snacks.nvim", words = { "Snacks" } },
        "nvim-dap-ui",
      },
    })
  end,
})
