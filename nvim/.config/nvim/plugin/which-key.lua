vim.pack.add({
  -- Dependencies
  "https://github.com/nvim-tree/nvim-web-devicons",

  "https://github.com/folke/which-key.nvim",
})

require("which-key").setup({
  preset = "helix",

  ---@type number | fun(ctx: { keys: string, mode: string, plugin?: string }):number
  delay = function(ctx) return (ctx.plugin and ctx.plugin ~= "marks") and 0 or 1000 end,

  ---@type wk.Spec
  spec = {
    { "<leader>g", group = "Git" },
    { "<leader>ga", group = "Add (Stage)" },
    { "<leader>gr", group = "Reset" },
    { "<leader>s", group = "Search" },
    { "<leader>t", group = "Toggle" },
    { "<leader>T", group = "Terminal" },
    { "<leader>X", group = "Exchange Treesitter node" },
    { "<leader>d", group = "Debugger" },
    { "<leader>l", group = "LSP Method" },
    { "<leader>o", group = "OpenCode", icon = "" },
    { "<leader>oa", group = "Ask with Context", icon = "󰁥" },
  },
})

vim.keymap.set("n", "<leader>?", function() require("which-key").show() end, { desc = "Available Keymaps" })
