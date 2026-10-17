vim.pack.add({
  -- Dependencies
  "https://github.com/saghen/blink.lib",

  {
    src = "https://github.com/saghen/blink.pairs",
    version = vim.version.range("0.7.0"), -- TODO: lock version until angle-bracket matching on HTML can be turned off
  },
})

local pairs = require("blink-pairs")
local utils = require("utils")

-- Download prebuilt binaries from GitHub releases (must be on a versioned release)
---@diagnostic disable-next-line: undefined-field
pairs.download():pwait(60000)

pairs.setup({
  mappings = {
    wrap = {
      ["<C-l>"] = "treesitter",
      ["<C-h>"] = "treesitter_reverse",
    },
    pairs = {
      -- Support for HTML elements
      [">"] = {
        {
          "<",
          open = false,
          backspace = false,
          enter = true,
          languages = {
            "html",
            "typescriptreact",
            "javascriptreact",
            "vue",
            "astro",
            "markdown",
            "markdown_inline",
          },
        },
      },
    },
  },
  highlights = {
    enabled = true,
    cmdline = false,
    groups = utils.pair_highlights,
    matchparen = {
      cmdline = false,
      include_surrounding = true,
    },
  },
})
