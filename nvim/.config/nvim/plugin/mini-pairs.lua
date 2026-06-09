vim.pack.add({ "https://github.com/nvim-mini/mini.pairs" })

require("mini.pairs").setup({
  modes = { insert = true, command = true, terminal = false },
  mappings = {
    -- Opening pairs
    ["["] = {
      action = "open",
      pair = "[]",
      neigh_pattern = ".[%s%z%)}%]]",
      -- The following applies to all braces/brackets/parentheses:
      -- foo|bar -> press "[" -> foo[bar
      -- foobar| -> press "[" -> foobar[]
      -- |foobar -> press "[" -> [foobar
      -- | foobar -> press "[" -> [] foobar
      -- foobar | -> press "[" -> foobar []
      -- {|} -> press "[" -> {[]}
      -- (|) -> press "[" -> ([])
      -- [|] -> press "[" -> [[]]
    },
    ["{"] = {
      action = "open",
      pair = "{}",
      neigh_pattern = ".[%s%z%)}%]]",
    },
    ["("] = {
      action = "open",
      pair = "()",
      neigh_pattern = ".[%s%z%)]",
    },

    -- Closing pairs
    [")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
    ["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
    ["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },

    -- Special mappings
    ["<"] = { action = "close", pair = "><" }, -- HTML/JSX tags
    [" "] = { action = "open", pair = "  ", neigh_pattern = "[({%[][%])}]" }, -- {|} -> <Space> -> { | }
    ["'"] = {
      action = "closeopen",
      pair = "''",
      neigh_pattern = "[^%w\\][^%w]", -- Handle contractions (e.g., "that's")
    },
  },
})
