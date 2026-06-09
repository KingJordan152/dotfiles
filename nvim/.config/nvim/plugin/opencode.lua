if not require("utils").executable_exists("opencode") then
  return
end

local opencode_cmd = "opencode --port"
---@type snacks.terminal.Opts
local snacks_terminal_opts = {
  win = {
    position = "right",
    enter = true,
  },
}

---@type opencode.Opts
vim.g.opencode_opts = {
  server = {
    start = function() require("snacks.terminal").open(opencode_cmd, snacks_terminal_opts) end,
  },
}

vim.pack.add({
  -- Dependencies
  "https://github.com/folke/snacks.nvim",

  "https://github.com/nickjvandyke/opencode.nvim",
})

local opencode = require("opencode")
vim.o.autoread = true -- Required for `opts.events.reload`

-- Toggle
vim.keymap.set({ "n", "t" }, "<C-.>", function() require("snacks.terminal").toggle(opencode_cmd, snacks_terminal_opts) end, { desc = "Toggle opencode" })

-- Open `select` dropdown with many options
vim.keymap.set({ "n", "x" }, "<leader>os", opencode.select, { desc = "Select option" })

-- General prompt to OpenCode
vim.keymap.set("n", "<leader>op", opencode.ask, { desc = "Prompt" })
vim.keymap.set("x", "<leader>op", function() opencode.ask("@this: ") end, { desc = "Prompt selection" })

-- Ask OpenCode with specific context
vim.keymap.set({ "n", "x" }, "<leader>oat", function() opencode.ask("@this: ") end, { desc = "@this" })
vim.keymap.set("n", "<leader>oa%", function() opencode.ask("@buffer: ") end, { desc = "@buffer" }) -- Similar to GitSigns `<leader>ga%`
vim.keymap.set("n", "<leader>oad", function() opencode.ask("@diagnostics: ") end, { desc = "@diagnostics" })

-- Add ranges to OpenCode's context
vim.keymap.set({ "n", "x" }, "go", function() return opencode.operator("@this ") end, { desc = "Add range to prompt", expr = true })
vim.keymap.set("n", "goo", function() return opencode.operator("@this ") .. "_" end, { desc = "Add line to prompt", expr = true })

-- Commands to control OpenCode TUI
vim.keymap.set("n", "<C-M-u>", function() opencode.command("session.half.page.up") end, { desc = "Scroll TUI up" })
vim.keymap.set("n", "<C-M-d>", function() opencode.command("session.half.page.down") end, { desc = "Scroll TUI down" })
vim.keymap.set("n", "<leader>o<Tab>", function() opencode.command("agent.cycle") end, { desc = "Cycle through agents" })
vim.keymap.set("n", "<leader>on", function() opencode.command("session.new") end, { desc = "Create a new session" })

vim.api.nvim_create_autocmd("User", {
  desc = "Open OpenCode TUI upon submitting a prompt",
  pattern = { "OpencodeEvent:tui.command.execute" },
  group = vim.api.nvim_create_augroup("opencode_auto_open", {}),
  callback = function(args)
    ---@type opencode.server.Event
    local event = args.data.event
    if event.properties.command == "prompt.submit" then
      local win = require("snacks.terminal").get(opencode_cmd, { create = false })
      if win then
        win:show()
      end
    end
  end,
})
