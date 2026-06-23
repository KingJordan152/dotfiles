vim.pack.add({ "https://github.com/nvim-mini/mini.pairs" })

---A neigh pattern that makes most pairs act similar to VS Code's autopair system.
---
---For example, the following behavior applies:
---
----foo|bar -> press "[" -> foo[bar
----foobar| -> press "[" -> foobar[]
----|foobar -> press "[" -> [foobar
----| foobar -> press "[" -> [] foobar
----foobar | -> press "[" -> foobar []
----{|} -> press "[" -> {[]}
----(|) -> press "[" -> ([])
----\[|\] -> press "[" -> [[]]
---
---Special cases are made for certain characters, like `=` and `;`
local vscode_neigh_pattern = ".[%s%z;:,=%)}%]<>`]"

require("mini.pairs").setup({
  modes = { insert = true, command = true, terminal = true },
  mappings = {
    -- Opening pairs
    ["["] = {
      action = "open",
      pair = "[]",
      neigh_pattern = vscode_neigh_pattern,
    },
    ["{"] = {
      action = "open",
      pair = "{}",
      neigh_pattern = vscode_neigh_pattern,
    },
    ["("] = {
      action = "open",
      pair = "()",
      neigh_pattern = vscode_neigh_pattern,
    },

    -- Special mappings
    ["<"] = { -- HTML/JSX tags
      action = "close",
      pair = "><",
      neigh_pattern = "[%z]", -- Throwaway pattern; prevents skipping over neighboring `<`
      register = { bs = false },
    },
    [" "] = { -- {|} -> <Space> -> { | }
      action = "open",
      pair = "  ",
      neigh_pattern = "[%({%[][%])}]",
      register = { bs = false },
    },
  },
})
