vim.pack.add({ "https://github.com/gbprod/substitute.nvim" })

local sub = require("substitute")
local sub_range = require("substitute.range")
local sub_exchange = require("substitute.exchange")

sub.setup({
  highlight_substituted_text = {
    enabled = true,
    timer = 150, -- Match highlight on yank timeout
  },
  range = {
    confirm = true,
  },
})

-- Substitute (replace)
vim.keymap.set("n", "gs", function()
  sub.operator({
    modifiers = { "reindent" },
  })
end, { desc = "Substitute" })

vim.keymap.set("n", "gss", function()
  sub.line({
    modifiers = { "reindent" },
  })
end, { desc = "Substitute line" })

vim.keymap.set("n", "gS", sub.eol, { desc = "Substitute (up to EOL)" })
vim.keymap.set("x", "gs", sub.visual, { desc = "Substitute" })

-- Range (substitutes a pattern over a specified motion via the command-line)
vim.keymap.set("n", "<leader>S", sub_range.operator, { desc = "Range substitution" })
vim.keymap.set("x", "<leader>S", sub_range.visual, { desc = "Range substitution" })
vim.keymap.set("n", "<leader>SS", sub_range.word, { desc = "Range substitution (word)" })

-- Exchange (swap values)
vim.keymap.set("n", "<leader>x", sub_exchange.operator, { desc = "Exchange" })
vim.keymap.set("n", "<leader>xx", sub_exchange.line, { desc = "Exchange line" })
vim.keymap.set("x", "<leader>xx", sub_exchange.visual, { desc = "Exchange" })
