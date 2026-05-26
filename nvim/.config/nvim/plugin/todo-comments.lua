vim.pack.add({
  -- Dependencies
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/folke/snacks.nvim",

  "https://github.com/folke/todo-comments.nvim",
})

-- TODO: Example :)

local utils = require("utils")

require("todo-comments").setup({
  keywords = {
    TODO = { icon = utils.icons.checkmark, color = "hint" },
    NOTE = { icon = utils.icons.diagnostics.info, color = "info", alt = { "INFO" } },
    TICKET = { icon = utils.icons.ticket, color = "ticket", alt = { "JIRA", "LINEAR" } },
  },
  highlight = {
    multiline = false,
  },
  colors = {
    ticket = { "#339CFF" },
  },
})

---@diagnostic disable-next-line: undefined-field
vim.keymap.set("n", "<leader>st", function() Snacks.picker.todo_comments() end, { desc = "All Todo Comments" })

---@diagnostic disable-next-line: undefined-field
vim.keymap.set("n", "<leader>sT", function() Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } }) end, { desc = "Todo/Fix/Fixme Comments" })

vim.keymap.set("n", "]t", function() require("todo-comments").jump_next() end, { desc = "Next todo comment" })

vim.keymap.set("n", "[t", function() require("todo-comments").jump_prev() end, { desc = "Previous todo comment" })
