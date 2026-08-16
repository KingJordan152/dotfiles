vim.pack.add({ "https://github.com/tpope/vim-fugitive" })

vim.keymap.set("n", "<C-S-G>", "<leader>gg", { remap = true })
vim.keymap.set("n", "<leader>gg", function()
  local fugitive_win = nil

  -- Only toggle the Fugitive window in the current tab
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)

    if vim.bo[buf].filetype == "fugitive" then
      fugitive_win = win
      break
    end
  end

  if fugitive_win then
    vim.api.nvim_win_close(fugitive_win, false)
  else
    vim.cmd("Git")
  end
end, { desc = "Toggle Fugitive summary window" })
