vim.pack.add({
  -- Dependencies
  "https://github.com/nvim-tree/nvim-web-devicons",

  "https://github.com/sindrets/diffview.nvim",
})

require("diffview").setup({
  enhanced_diff_hl = true,
  view = {
    merge_tool = {
      layout = "diff3_mixed",
    },
  },
  hooks = {
    diff_buf_win_enter = function(_, winid)
      -- Turn off cursor line for diffview windows because of bg conflict.
      -- See https://github.com/neovim/neovim/issues/9800
      vim.wo[winid].culopt = "number"
    end,
  },
})
