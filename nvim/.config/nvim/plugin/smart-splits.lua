---@diagnostic disable: missing-fields
vim.pack.add({
  -- Dependencies (backends)
  "https://github.com/smart-splits-nvim/backend-tmux",

  "https://github.com/smart-splits-nvim/smart-splits.nvim",
})

local smart_splits = require("smart-splits")

smart_splits.setup({
  move = {
    at_edge = "stop",
    float = "mux",
  },
  swap = {
    move_cursor = true,
  },
  resize = {
    amount = 2,
  },
  mux = {
    backend = { "smart-splits-backend-tmux" },
    warn_if_unusable = false,
  },
})

-- Moving between splits
vim.keymap.set("n", "<C-h>", smart_splits.move_cursor_left, { desc = "Go to the left window" })
vim.keymap.set("n", "<C-j>", smart_splits.move_cursor_down, { desc = "Go to the lower window" })
vim.keymap.set("n", "<C-k>", smart_splits.move_cursor_up, { desc = "Go to the upper window" })
vim.keymap.set("n", "<C-l>", smart_splits.move_cursor_right, { desc = "Go to the right window" })

-- Resizing splits
vim.keymap.set("n", "<C-M-h>", smart_splits.resize_left, { desc = "Resize split left" })
vim.keymap.set("n", "<C-M-j>", smart_splits.resize_down, { desc = "Resize split down" })
vim.keymap.set("n", "<C-M-k>", smart_splits.resize_up, { desc = "Resize split up" })
vim.keymap.set("n", "<C-M-l>", smart_splits.resize_right, { desc = "Resize split right" })

-- Swapping buffers between windows
vim.keymap.set("n", "<C-S-h>", smart_splits.swap_buf_left, { desc = "Swap current window with the left window" })
vim.keymap.set("n", "<C-S-j>", smart_splits.swap_buf_down, { desc = "Swap current window with the lower window" })
vim.keymap.set("n", "<C-S-k>", smart_splits.swap_buf_up, { desc = "Swap current window with the upper window" })
vim.keymap.set("n", "<C-S-l>", smart_splits.swap_buf_right, { desc = "Swap current window with the right window" })
