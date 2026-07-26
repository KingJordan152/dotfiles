vim.pack.add({
  -- Dependencies
  "https://github.com/HiPhish/rainbow-delimiters.nvim",

  "https://github.com/lukas-reineke/indent-blankline.nvim",
})

local utils = require("utils")
local hooks = require("ibl.hooks")
local highlight = {
  -- "RainbowDelimiterRed", (usually indicates error)
  -- "RainbowDelimiterOrange", (too similar to yellow)
  "RainbowDelimiterBlue",
  "RainbowDelimiterViolet",
  "RainbowDelimiterCyan",
  "RainbowDelimiterGreen",
  "RainbowDelimiterYellow",
}
local css_nodes = utils.list_to_table(utils.css_filetypes, function()
  return {
    "block",
  }
end)

-- Ensures Rainbow Delimiters and Indent Blankline highlight groups are synced
vim.g.rainbow_delimiters = vim.tbl_deep_extend("keep", vim.g.rainbow_delimiters, { highlight = highlight })
hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)

require("ibl").setup({
  debounce = 100,
  indent = {
    char = "▏",
  },
  scope = {
    show_start = false,
    show_end = false,
    highlight = highlight,
    include = {
      node_type = vim.tbl_extend("error", {
        ["*"] = {
          "table_constructor",
          "if_statement",
          "ternary_expression",
          "parenthesized_statement",
          "parenthesized_expression",
          "object",
          "object_pattern",
          "object_type",
          "interface_body",
          "enum_body",
          "arguments", -- TS/JS: argument list that's written across multiple lines
          "import_clause", -- TS/JS: multiple exports from a single module listed across multiple lines
          "class_body",
          "switch_statement",
        },
      }, css_nodes),
    },
    exclude = {
      language = { "yaml" },
      node_type = {
        ["*"] = {
          "jsx_element",
          "element",
        },
      },
    },
  },
  exclude = {
    filetypes = { "diff" },
  },
})
