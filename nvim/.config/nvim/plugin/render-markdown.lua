vim.pack.add({
  -- Dependencies
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/nvim-tree/nvim-web-devicons",

  "https://github.com/MeanderingProgrammer/render-markdown.nvim",
})

require("render-markdown").setup({
  completions = { lsp = { enabled = true } },
  render_modes = true, -- Show formatted text even while in insert mode
  file_types = { "markdown", "gitcommit" },

  heading = {
    border = true,
    border_virtual = true,
    position = "inline",
    left_pad = 2,
  },
  code = {
    -- Don't add any padding/margin because it **will** mess up indent lines
    width = "block",
    min_width = 45,
    border = "thick",
  },
  pipe_table = {
    preset = "round",
    border_virtual = true,
  },
  overrides = {
    filetype = {
      gitcommit = { heading = { enabled = false } },
    },
    buftype = {
      -- Applies to LSP Hover windows
      nofile = {
        anti_conceal = {
          enabled = false,
        },
        code = {
          language = false,
          left_pad = 0,
          right_pad = 0,
          border = "hide",
        },
      },
    },
  },
  win_options = {
    wrap = { default = true, rendered = true },
    breakindent = { default = true, rendered = true },
    breakindentopt = { default = "list:-1", rendered = "list:-1" },
    linebreak = { default = true, rendered = true },
  },
})
