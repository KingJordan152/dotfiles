local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local hybrid_line_numbers = augroup("hybrid_line_numbers", { clear = true })

autocmd("InsertEnter", {
  desc = "Disable relative line numbers when entering Insert mode",
  group = hybrid_line_numbers,
  callback = function(args)
    if vim.bo[args.buf].modifiable then
      vim.o.relativenumber = false
    end
  end,
})

autocmd("InsertLeave", {
  desc = "Enable relative line numbers when leaving Insert mode",
  group = hybrid_line_numbers,
  callback = function(args)
    if vim.bo[args.buf].modifiable then
      vim.o.relativenumber = true
    end
  end,
})

autocmd("TextYankPost", {
  desc = "Briefly highlight yanked text",
  group = augroup("highlight_yank", { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

autocmd("FileType", {
  desc = "Add special 'close' keymap to unmodifiable buffers",
  group = augroup("readonly_keymaps", { clear = true }),
  pattern = "*",
  callback = function(args)
    local bufnr = args.buf
    local excluded_filetypes = {
      "oil",
      "fugitive",
    }

    if not vim.bo[bufnr].modifiable and not vim.list_contains(excluded_filetypes, vim.bo[bufnr].filetype) then
      vim.keymap.set("n", "gq", "<Cmd>q<CR>", {
        desc = "Quit the current window",
        buf = bufnr,
      })
    end
  end,
})

autocmd("VimResized", {
  desc = "Automatically resize splits when the terminal's window is resized",
  group = augroup("equalize_splits", { clear = true }),
  callback = function()
    local current_tab = vim.api.nvim_get_current_tabpage()

    vim.cmd("tabdo wincmd =")
    vim.api.nvim_set_current_tabpage(current_tab)
  end,
})

-- Requires `vim.o.autoread = true` in order to work.
-- By default, Neovim does this for the `FocusGained` event but not `BufEnter`.
autocmd("BufEnter", {
  desc = "Check file for external changes upon entering its buffer",
  pattern = "*",
  group = augroup("autoread_file_on_bufenter", {}),
  command = "if mode() != 'c' | checktime | endif",
})

-- Makes Neovim terminals behave more like regular terminals
autocmd("TermOpen", {
  desc = "Enable wrap for all terminal buffers",
  group = augroup("enable_terminal_wrap", {}),
  pattern = "*",
  command = "setlocal wrap",
})
