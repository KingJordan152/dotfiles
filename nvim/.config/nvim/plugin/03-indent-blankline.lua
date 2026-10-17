vim.pack.add({
  "https://github.com/lukas-reineke/indent-blankline.nvim",
})

local utils = require("utils")
local hooks = require("ibl.hooks")
local highlights = require("plugin.02-blink-pairs").highlights
local css_nodes = utils.list_to_table(utils.css_filetypes, function()
  return {
    "block",
  }
end)

-- Ensures `blink.pairs` and `indent-blankline` highlight groups are synced
hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)

require("ibl").setup({
  debounce = 100,
  indent = {
    char = "▏",
  },
  scope = {
    show_start = false,
    show_end = false,
    highlight = highlights,
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
