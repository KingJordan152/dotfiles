vim.pack.add({
  -- Dependencies
  "https://github.com/nvim-treesitter/nvim-treesitter",

  "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
})

-- Disable entire built-in ftplugin mappings to avoid conflicts.
-- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
vim.g.no_plugin_maps = true

require("nvim-treesitter-textobjects").setup({
  select = {
    -- Makes custom textobjects work more closely to native textobjects
    lookahead = true,
    include_surrounding_whitespace = true,
  },
  move = {
    set_jumps = true,
  },
})

-- "Swap" Keymaps
vim.keymap.set("n", "<leader>Xa", function() require("nvim-treesitter-textobjects.swap").swap_next("@attribute.outer") end, { desc = "Next attribute" })
vim.keymap.set("n", "<leader>XA", function() require("nvim-treesitter-textobjects.swap").swap_previous("@attribute.outer") end, { desc = "Previous attribute" })
vim.keymap.set(
  "n",
  "<leader>Xr",
  function() require("nvim-treesitter-textobjects.swap").swap_next("@parameter.outer") end,
  { desc = "Next pa[r]ameter/a[r]gument" }
)
vim.keymap.set(
  "n",
  "<leader>XR",
  function() require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.outer") end,
  { desc = "Previous pa[r]ameter/a[r]gument" }
)

-- "Selection" Keymaps
vim.keymap.set(
  { "x", "o" },
  "af",
  function() require("nvim-treesitter-textobjects.select").select_textobject("@call.outer", "textobjects") end,
  { desc = "function call" }
)
vim.keymap.set(
  { "x", "o" },
  "if",
  function() require("nvim-treesitter-textobjects.select").select_textobject("@call.inner", "textobjects") end,
  { desc = "inner function call" }
)
vim.keymap.set(
  { "x", "o" },
  "am",
  function() require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects") end,
  { desc = "method" }
)
vim.keymap.set(
  { "x", "o" },
  "im",
  function() require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects") end,
  { desc = "inner method" }
)
vim.keymap.set(
  { "x", "o" },
  "ac",
  function() require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects") end,
  { desc = "class" }
)
vim.keymap.set(
  { "x", "o" },
  "ic",
  function() require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects") end,
  { desc = "inner class" }
)
vim.keymap.set(
  { "x", "o" },
  "aa",
  function() require("nvim-treesitter-textobjects.select").select_textobject("@attribute.outer", "textobjects") end,
  { desc = "attribute" }
)
vim.keymap.set(
  { "x", "o" },
  "ia",
  function() require("nvim-treesitter-textobjects.select").select_textobject("@attribute.inner", "textobjects") end,
  { desc = "inner attribute" }
)
vim.keymap.set(
  { "x", "o" },
  "ar",
  function() require("nvim-treesitter-textobjects.select").select_textobject("@parameter.outer", "textobjects") end,
  { desc = "pa[r]ameter/a[r]gument" }
)
vim.keymap.set(
  { "x", "o" },
  "ir",
  function() require("nvim-treesitter-textobjects.select").select_textobject("@parameter.inner", "textobjects") end,
  { desc = "inner pa[r]ameter/a[r]gument" }
)

-- Movement Keymaps (Start-Position)
vim.keymap.set(
  { "n", "x", "o" },
  "]f",
  function() require("nvim-treesitter-textobjects.move").goto_next_start("@call.outer", "textobjects") end,
  { desc = "Next function call start" }
)
vim.keymap.set(
  { "n", "x", "o" },
  "[f",
  function() require("nvim-treesitter-textobjects.move").goto_previous_start("@call.outer", "textobjects") end,
  { desc = "Previous function call start" }
)
vim.keymap.set(
  { "n", "x", "o" },
  "]m",
  function() require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects") end,
  { desc = "Next method start" }
)
vim.keymap.set(
  { "n", "x", "o" },
  "[m",
  function() require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects") end,
  { desc = "Previous method start" }
)
vim.keymap.set(
  { "n", "x", "o" },
  "]c",
  function() require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects") end,
  { desc = "Next class start" }
)
vim.keymap.set(
  { "n", "x", "o" },
  "[c",
  function() require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects") end,
  { desc = "Previous class start" }
)
vim.keymap.set(
  { "n", "x", "o" },
  "]a",
  function() require("nvim-treesitter-textobjects.move").goto_next_start("@attribute.outer", "textobjects") end,
  { desc = "Next attribute start" }
)
vim.keymap.set(
  { "n", "x", "o" },
  "[a",
  function() require("nvim-treesitter-textobjects.move").goto_previous_start("@attribute.outer", "textobjects") end,
  { desc = "Previous attribute start" }
)
vim.keymap.set(
  { "n", "x", "o" },
  "]r",
  function() require("nvim-treesitter-textobjects.move").goto_next_start("@argument.outer", "textobjects") end,
  { desc = "Next pa[r]ameter/a[r]gument start" }
)
vim.keymap.set(
  { "n", "x", "o" },
  "[r",
  function() require("nvim-treesitter-textobjects.move").goto_previous_start("@argument.outer", "textobjects") end,
  { desc = "Previous pa[r]ameter/a[r]gument start" }
)
vim.keymap.set(
  { "n", "x", "o" },
  "]/",
  function() require("nvim-treesitter-textobjects.move").goto_next_start("@comment.outer", "textobjects") end,
  { desc = "Next comment" }
)
vim.keymap.set(
  { "n", "x", "o" },
  "[/",
  function() require("nvim-treesitter-textobjects.move").goto_previous_start("@comment.outer", "textobjects") end,
  { desc = "Previous comment" }
)
vim.keymap.set(
  { "n", "x", "o" },
  "]z",
  function() require("nvim-treesitter-textobjects.move").goto_next_start("@fold", "folds") end,
  { desc = "Next fold start" }
)
vim.keymap.set(
  { "n", "x", "o" },
  "[z",
  function() require("nvim-treesitter-textobjects.move").goto_previous_start("@fold", "folds") end,
  { desc = "Previous fold start" }
)

-- Movement Keymps (End-Position)
vim.keymap.set(
  { "n", "x", "o" },
  "]F",
  function() require("nvim-treesitter-textobjects.move").goto_next_end("@call.outer", "textobjects") end,
  { desc = "Next function call end" }
)
vim.keymap.set(
  { "n", "x", "o" },
  "[F",
  function() require("nvim-treesitter-textobjects.move").goto_previous_end("@call.outer", "textobjects") end,
  { desc = "Previous function call end" }
)
vim.keymap.set(
  { "n", "x", "o" },
  "]M",
  function() require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects") end,
  { desc = "Next method end" }
)
vim.keymap.set(
  { "n", "x", "o" },
  "[M",
  function() require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects") end,
  { desc = "Previous method end" }
)
vim.keymap.set(
  { "n", "x", "o" },
  "]C",
  function() require("nvim-treesitter-textobjects.move").goto_next_end("@class.outer", "textobjects") end,
  { desc = "Next class end" }
)
vim.keymap.set(
  { "n", "x", "o" },
  "[C",
  function() require("nvim-treesitter-textobjects.move").goto_previous_end("@class.outer", "textobjects") end,
  { desc = "Previous class end" }
)
vim.keymap.set(
  { "n", "x", "o" },
  "]A",
  function() require("nvim-treesitter-textobjects.move").goto_next_end("@attribute.outer", "textobjects") end,
  { desc = "Next attribute end" }
)
vim.keymap.set(
  { "n", "x", "o" },
  "[A",
  function() require("nvim-treesitter-textobjects.move").goto_previous_end("@attribute.outer", "textobjects") end,
  { desc = "Previous attribute end" }
)
vim.keymap.set(
  { "n", "x", "o" },
  "]R",
  function() require("nvim-treesitter-textobjects.move").goto_next_end("@argument.outer", "textobjects") end,
  { desc = "Next pa[r]ameter/a[r]gument end" }
)
vim.keymap.set(
  { "n", "x", "o" },
  "[R",
  function() require("nvim-treesitter-textobjects.move").goto_previous_end("@argument.outer", "textobjects") end,
  { desc = "Previous pa[r]ameter/a[r]gument end" }
)
vim.keymap.set({ "n", "x", "o" }, "]Z", function() require("nvim-treesitter-textobjects.move").goto_next_end("@fold", "folds") end, { desc = "Next fold end" })
vim.keymap.set(
  { "n", "x", "o" },
  "[Z",
  function() require("nvim-treesitter-textobjects.move").goto_previous_end("@fold", "folds") end,
  { desc = "Previous fold end" }
)
