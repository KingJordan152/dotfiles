vim.pack.add({
  -- Dependencies
  "https://github.com/folke/tokyonight.nvim",

  "https://github.com/nvim-lualine/lualine.nvim",
})

local utils = require("utils")
local colors = require("tokyonight.colors").setup()

-- Setup a `filename` component that includes a filetype icon and becomes bold when the buffer has been modified.
local custom_filename = require("lualine.components.filename"):extend()
custom_filename.apply_icon = require("lualine.components.filetype").apply_icon
custom_filename.icon_hl_cache = {} -- Ensures the filename component renders properly with the right colors.
local highlight = require("lualine.highlight")

---Initialize the filename component to have different colors when modified/saved.
function custom_filename:init(options)
  custom_filename.super.init(self, options)
  self.status_colors = {
    saved = highlight.create_component_highlight_group({ gui = "" }, "filename_status_saved", self.options),
    modified = highlight.create_component_highlight_group({ gui = "bold" }, "filename_status_modified", self.options),
  }
  if self.options.color == nil then
    self.options.color = ""
  end
end

---Ensure the filename's color updates whenever the buffer is either modified or saved.
function custom_filename:update_status()
  local data = custom_filename.super.update_status(self)
  data = highlight.component_format_highlight(vim.bo.modified and self.status_colors.modified or self.status_colors.saved) .. data
  return data
end

---Determines the formatters that will run against the current buffer.
---
---If there aren't any configured formatters for the current buffer *but* it has an LSP,
---`"LSP"` will be returned.
---
---If there are neither formatters nor LSPs configured for the current buffer, the empty string will be returned.
---@return string
local function formatter_status()
  local conform = require("conform")
  local formatters_for_current_buffer, lsp_fallback = conform.list_formatters_to_run(0)
  local result = ""

  if next(formatters_for_current_buffer) == nil then
    if lsp_fallback then
      result = result .. "LSP"
    else
      result = ""
    end
  else
    for i, formatter in ipairs(formatters_for_current_buffer) do
      local separator = i == 1 and "" or ", "
      result = result .. separator .. formatter.name
    end
  end

  return result
end

---Displays an icon for each enabled `Snacks` toggle that has an associated icon in `utils.icons`.
---@return string
local function toggle_status()
  local enabled_toggles = {}

  for k, v in pairs(utils.icons.toggles) do
    local is_enabled = Snacks.toggle.toggles[k]:get()

    if is_enabled then
      table.insert(enabled_toggles, v)
    end
  end

  if #enabled_toggles == 0 then
    return ""
  end

  -- Ensure the icons are displayed in the same order every time.
  table.sort(enabled_toggles)

  return table.concat(enabled_toggles, "  ") .. " " -- Pad component with extra space, otherwise it looks awkward
end

require("lualine").setup({
  options = {
    -- Use the "auto" theme but change the "inactive" background color to be more visible.
    -- This helps draw a more distinguishable border between horizontal inactive and active windows.
    theme = vim.tbl_deep_extend("force", require("lualine.themes.auto"), {
      inactive = {
        c = { bg = colors.bg },
      },
    }),
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    globalstatus = true,
  },
  sections = {
    lualine_a = {
      {
        "mode",
        separator = { left = "", right = "" },
      },
    },
    lualine_b = {
      {
        "branch",
        icon = utils.icons.git.branch,
        draw_empty = true,
      },
      {
        "diff",
        symbols = {
          added = utils.icons.git.file.added,
          modified = utils.icons.git.file.modified,
          removed = utils.icons.git.file.deleted,
        },
      },
    },
    lualine_c = {
      {
        custom_filename,
        colored = true,
        symbols = {
          modified = "●",
          readonly = "",
        },
      },
      {
        "grapple",
        color = { fg = colors.blue },
        cond = function() return not utils.Set({ "snacks_picker_input", "snacks_picker_list" })[vim.bo.filetype] end,
      },
    },
    lualine_x = {
      {
        "lsp_status",
        icon = { "", color = { fg = colors.blue1 } },
        symbols = {
          done = "",
          separator = ", ",
        },
        ignore_lsp = {
          "cssmodules_ls",
          "css_variables",
          "stylua",
          "tailwindcss",
          "emmet_language_server",
          "render-markdown",
        },
      },
      {
        formatter_status,
        icon = { utils.icons.formatting, color = { fg = colors.yellow } },
        -- If formatting is disabled, make the component red with a strikethrough.
        color = function()
          if vim.b.disable_autoformat or vim.g.disable_autoformat then
            return { fg = colors.red, gui = "strikethrough" }
          end
          return "lualine_c_normal"
        end,
      },
      {
        option_toggle_status,
        color = { fg = colors.green },
      },
      {
        "diagnostics",
        sections = { "error", "warn" },
        symbols = {
          error = utils.icons.diagnostics.error,
          warn = utils.icons.diagnostics.warn,
          hint = utils.icons.diagnostics.hint,
          info = utils.icons.diagnostics.info,
        },
        always_visible = true,
        cond = function()
          return not utils.Set({
            "help",
            "snacks_picker_input",
            "snacks_picker_list",
            "gitcommit",
          })[vim.bo.filetype]
        end,
      },
    },
    lualine_y = { "progress" },
    lualine_z = {
      {
        "location",
        separator = { left = "", right = "" },
      },
    },
  },
  inactive_sections = {
    lualine_c = {
      {
        custom_filename,
        symbols = {
          modified = "●",
          readonly = "",
        },
        colored = true,
        color = { fg = colors.fg_dark },
      },
    },
    lualine_x = {
      {
        "location",
        colored = true,
        color = { fg = colors.fg_dark },
      },
    },
  },
  extensions = {
    "quickfix",
    "lazy",
    "mason",
    "man",
    "oil",
    "fugitive",
  },
})
