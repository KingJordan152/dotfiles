vim.loader.enable() -- Experimental; can significantly improve startup time

require("options")
require("autocmds")
require("lsp")
require("keymaps")
require("diagnostics")
require("user-commands")

if os.getenv("TMUX") then
  ---Wraps `content` with `tmux` prefix so that the terminal can interpret it correctly.
  ---Needs `set-option -g allow-passthrough on` in tmux config.
  ---
  ---See [[https://www.reddit.com/r/neovim/comments/1sacc91/comment/oe1n62i/]]
  ---@param content string
  ---@return string
  local function wrap_tmux(content) return string.format("\27Ptmux;\27%s\27\\", content) end

  local original_ui_send = vim.api.nvim_ui_send

  ---@diagnostic disable-next-line: duplicate-set-field
  vim.api.nvim_ui_send = function(content)
    -- Enable "Progress Bar" sequences within `tmux`
    local is_progress_bar = content:find("\27]9;4;")
    original_ui_send(is_progress_bar and wrap_tmux(content) or content)
  end
end
