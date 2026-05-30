vim.pack.add({ "https://github.com/shortcuts/no-neck-pain.nvim" })

require("no-neck-pain").setup({
  width = 110,
})

-- Must setup autocmd here because the one in `setup` won't update when the global variable changes
vim.api.nvim_create_autocmd("VimEnter", {
  desc = "Activate NoNeckPain on startup if it was toggled on before quit",
  group = vim.api.nvim_create_augroup("no_neck_pain_startup", {}),
  callback = function()
    if vim.g.enable_no_neck_pain then
      vim.cmd("NoNeckPain")
    end
  end,
})
