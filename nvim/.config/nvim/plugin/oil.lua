vim.pack.add({
  -- Dependencies
  "https://github.com/nvim-tree/nvim-web-devicons",

  -- Extensions
  "https://github.com/JezerM/oil-lsp-diagnostics.nvim",
  "https://github.com/malewicz1337/oil-git.nvim",

  -- Plugin
  "https://github.com/stevearc/oil.nvim",
})

require('oil-lsp-diagnostics').setup({
  error = " ",
  warn = "",
  info = "",
  hint = "󰌶",
})

require('oil-git').setup({
  show_directory_highlights = false,
  symbol_position = "signcolumn",
  symbols = {
    file = {
      added = "",
      modified = "",
      deleted = "",
      copied = "",
      renamed = "",
      untracked = "",
      conflict = "",
      ignored = "",
    },
    directory = {
      added = "󱞩",
      modified = "󱞩",
      renamed = "󱞩",
      deleted = "󱞩",
      copied = "󱞩",
      conflict = "",
      untracked = "",
      ignored = "",
    },
  },
  highlights = {
    OilGitAdded = { link = "GitSignsAdd" },
    OilGitModified = { link = "GitSignsChange" },
    OilGitDeleted = { link = "GitSignsDelete" },
    OilGitUntracked = { link = "GitSignsUntracked" },
    -- OilGitRenamed = { fg = "#cba6f7" },
    -- OilGitCopied = { fg = "#cba6f7" },
    -- OilGitConflict = { fg = "#fab387" },
    -- OilGitIgnored = { fg = "#6c7086" },
  },
})

require('oil').setup({
  default_file_explorer = true,
  watch_for_changes = true,
  skip_confirm_for_simple_edits = true,
  lsp_file_methods = {
    enabled = true,
    timeout_ms = 1000,
    autosave_changes = true,
  },
  view_options = {
    show_hidden = true,
    is_always_hidden = function(name)
      local files = {
        [".DS_Store"] = true,
        [".git"] = true,
      }
      return files[name]
    end,
  },
  win_options = {
    signcolumn = vim.o.signcolumn,
  },
  keymaps = {
    ["<C-c>"] = false, -- Replace with below keymap
    ["q"] = "actions.close",
    ["<C-q>"] = "actions.send_to_qflist",
    ["<leader>%"] = {
      desc = "Copy relative path",
      "actions.yank_entry",
      opts = {
        modify = ":p:.",
      },
    },
    ["<leader>~"] = {
      desc = "Copy full path",
      "actions.yank_entry",
      opts = {
        modify = ":p:~",
      },
    },
    ["gy"] = "actions.copy_to_system_clipboard",
    ["gp"] = "actions.paste_from_system_clipboard",
    ["<CR>"] = {
      --- Open the file under the cursor, but also remove all search highlights.
      --- This is helpful for when you're searching for a file inside a Oil buffer but don't want
      --- that search highlighting to persist once you've made a selection.
      function()
        require("oil").select()
        vim.cmd("nohlsearch")
      end,
    },
    ["gd"] = {
      desc = "Toggle file detail view",
      callback = function()
        vim.g.oil_detail = not vim.g.oil_detail

        if vim.g.oil_detail then
          require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
        else
          require("oil").set_columns({ "icon" })
        end
      end,
    },
  },
})

vim.keymap.set("n", "<leader>e", "<cmd>Oil<CR>", { desc = "Open file browser [Oil]" })
