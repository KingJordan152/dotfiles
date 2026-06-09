vim.pack.add({
  -- Dependencies
  "https://github.com/JoosepAlviste/nvim-ts-context-commentstring",

  "https://github.com/nvim-mini/mini.comment",
})

-- NECESSARY; ensures JSX/TSX files apply correct commentstring based Treesitter node.
-- e.g., JSX attributes -> '// %s'; JSX Elements -> '{/* %s */}'
require("ts_context_commentstring").setup({
  enable_autocmd = false,
})

require("mini.comment").setup({
  options = {
    custom_commentstring = function() return require("ts_context_commentstring").calculate_commentstring() or vim.bo.commentstring end,
  },
})

-- ==== Keymap Helper Functions ====

---Splits the given `commentstring` into its left and right side.
---The user's comment is expected to go between both sides.
---@param commentstring string String that will be decomposed. Must contain a special `%s` sequence.
---@return string|nil l_cms, string|nil r_cms
local function decompose_commentstring(commentstring)
  if not commentstring then
    return
  end

  local l_cms, r_cms = string.match(commentstring, "(.*)%%s(.*)")
  l_cms = vim.trim(l_cms) .. " "
  r_cms = vim.trim(r_cms)

  -- Handle case where there is a right commentstring (i.e., block comments)
  if #r_cms ~= 0 then
    r_cms = " " .. r_cms
  end

  return l_cms, r_cms
end

---Insert a new comment either above or below the cursor's current position.
---@param offset integer Distance away from the cursor's current position.
---`0` is immediately below; `1` is immediately above
local function insert_comment_above_or_below(offset)
  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
  local comment_row = row + offset
  local l_cms, r_cms = decompose_commentstring(require("ts_context_commentstring").calculate_commentstring() or vim.bo.commentstring)

  vim.api.nvim_buf_set_lines(0, comment_row, comment_row, false, { l_cms .. r_cms }) -- Add new line with commentstring
  vim.api.nvim_win_set_cursor(0, { comment_row + 1, 0 }) -- Move cursor to the new line
  vim.api.nvim_command("normal! ==") -- Set the correct indentation level
  vim.api.nvim_win_set_cursor(0, { comment_row + 1, #vim.api.nvim_get_current_line() - #r_cms - 1 }) -- Move cursor inside the commentstring
  vim.api.nvim_feedkeys("a", "ni", true) -- Enter Insert mode
end

---Insert a new comment at the end of the current line.
local function insert_comment_eol()
  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
  local l_cms, r_cms = decompose_commentstring(require("ts_context_commentstring").calculate_commentstring() or vim.bo.commentstring)

  vim.api.nvim_set_current_line(vim.api.nvim_get_current_line() .. " " .. l_cms .. r_cms) -- Add commenstring to EOL
  vim.api.nvim_command("normal! ==") -- If on new line, indent it
  vim.api.nvim_win_set_cursor(0, { row, #vim.api.nvim_get_current_line() - #r_cms - 1 }) -- Move cursor to appropriate location
  vim.api.nvim_feedkeys("a", "ni", true) -- Enter Insert mode
end

-- ==== Keymaps (Inspired by Comment.nvim) ====

vim.keymap.set("n", "gco", function() insert_comment_above_or_below(0) end, { desc = "Insert comment below" })
vim.keymap.set("n", "gcO", function() insert_comment_above_or_below(-1) end, { desc = "Insert comment above" })
vim.keymap.set("n", "gcA", insert_comment_eol, { desc = "Insert comment at the end of the line" })
