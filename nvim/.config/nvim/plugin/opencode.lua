if not require("utils").executable_exists("opencode") then
  return
end

vim.pack.add({
  -- Dependencies
  "https://github.com/folke/snacks.nvim",

  "https://github.com/nickjvandyke/opencode.nvim",
})

local opencode = require("opencode")
vim.o.autoread = true -- Required for `opts.events.reload`

-- Toggles
vim.keymap.set({ "n", "t", "i", "x" }, "<C-.>", opencode.toggle, { desc = "Toggle OpenCode" })
vim.keymap.set({ "n", "x" }, "<leader>oo", opencode.toggle, { desc = "Toggle TUI" })

-- Open `select` dropdown with many options
vim.keymap.set({ "n", "x" }, "<leader>os", opencode.select, { desc = "Select option" })

-- General prompt to OpenCode
vim.keymap.set("n", "<leader>op", opencode.ask, { desc = "Prompt" })
vim.keymap.set("x", "<leader>op", function() opencode.ask("@this: ", { submit = true }) end, { desc = "Prompt selection" })

-- Ask OpenCode with specific context
vim.keymap.set({ "n", "x" }, "<leader>oat", function() opencode.ask("@this: ", { submit = true }) end, { desc = "@this" })
vim.keymap.set("n", "<leader>oa%", function() opencode.ask("@buffer: ", { submit = true }) end, { desc = "@buffer" }) -- Similar to GitSigns `<leader>ga%`
vim.keymap.set("n", "<leader>oad", function() opencode.ask("@diagnostics: ", { submit = true }) end, { desc = "@diagnostics" })

-- Add ranges to OpenCode's context
vim.keymap.set({ "n", "x" }, "go", function() return opencode.operator("@this ") end, { desc = "Add range to prompt", expr = true })
vim.keymap.set("n", "goo", function() return opencode.operator("@this ") .. "_" end, { desc = "Add line to prompt", expr = true })

-- Commands to control OpenCode TUI
vim.keymap.set("n", "<S-C-u>", function() opencode.command("session.half.page.up") end, { desc = "Scroll TUI up" })
vim.keymap.set("n", "<S-C-d>", function() opencode.command("session.half.page.down") end, { desc = "Scroll TUI down" })
vim.keymap.set("n", "<leader>ol", function() opencode.command("session.list") end, { desc = "List sessions" })
vim.keymap.set("n", "<leader>o<tab>", function() opencode.command("agent.cycle") end, { desc = "Cycle through agents" })

-- Enhance `Snacks` picker with OpenCode features
require("snacks").config = {
  picker = {
    actions = {
      opencode_send = function(...) return require("opencode").snacks_picker_send(...) end,
    },
    win = {
      input = {
        keys = {
          ["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
        },
      },
    },
  },
}
