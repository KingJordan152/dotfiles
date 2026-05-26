vim.pack.add({
  -- Dependencies
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/folke/snacks.nvim",

  "https://github.com/folke/todo-comments.nvim",
})

-- TODO: Example :)

require("todo-comments").setup({
  keywords = {
    TODO = { icon = " ", color = "hint" },
    NOTE = { icon = " ", color = "info", alt = { "INFO" } },
    TICKET = { icon = " ", color = "ticket", alt = { "JIRA", "LINEAR" } },
  },
  highlight = {
    multiline = false,
  },
  colors = {
    ticket = { "#339CFF" },
  },
})

vim.keymap.set("n", "<leader>st", function()
  ---@diagnostic disable-next-line: undefined-field
  require("snacks").picker.todo_comments()
end, { desc = "All Todo Comments" })

vim.keymap.set("n", "<leader>sT", function()
  ---@diagnostic disable-next-line: undefined-field
  require("snacks").picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } })
end, { desc = "Todo/Fix/Fixme Comments" })

vim.keymap.set("n", "]t", function() require("todo-comments").jump_next() end, { desc = "Next todo comment" })

vim.keymap.set("n", "[t", function() require("todo-comments").jump_prev() end, { desc = "Previous todo comment" })
