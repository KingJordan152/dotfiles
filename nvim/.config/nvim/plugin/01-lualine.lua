vim.pack.add({
  -- Dependencies
  "https://github.com/folke/tokyonight.nvim",
  "https://github.com/cbochs/grapple.nvim", -- Provides a custom component

  "https://github.com/nvim-lualine/lualine.nvim",
})

local utils = require("utils")
local colors = require("tokyonight.colors").setup()
local left_edge_separators = { left = "", right = "" }
local right_edge_separators = { left = "", right = "" }

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

---Custom statusline for `:help` buffers (similar to "man" extension)
local help_extension = {
  filetypes = { "help" },
  sections = {
    lualine_a = { function() return "HELP" end },
    lualine_b = { { "filename", file_status = false } },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
}

-- "Fugitive" extension doesn't use `icon` key; this fixes that and uses custom branch icon
require("lualine.extensions.fugitive").sections.lualine_a = {
  {
    function() return vim.fn.FugitiveHead() end,
    icon = utils.icons.git.branch,
  },
}

---Inserts custom "edge separators" into a given statusline config.
---"Edge separators" here are defined as the icons used for the very edge of either side of the statusline.
---@param config table Statusline section config to add edge separators into.
---@return table|nil
local function insert_edge_separators(config)
  local modified_config = config

  -- Indicates an invalid component was passed.
  if not (config and config.sections) then
    return
  end

  ---Adds the correct separators to the designated edge.
  ---Modifies `section` in-place.
  ---@param section table
  ---@param edge "left"|"right"
  local function modify_section(section, edge)
    local separators = edge == "left" and left_edge_separators or right_edge_separators

    -- Indicates section doesn't have any components
    if not section then
      return
    end

    if type(section[1]) == "function" or type(section[1]) == "string" then
      -- Must construct a new table wherein the `separator` key can be added
      section[1] = {
        section[1],
        separator = separators,
      }
    elseif type(section[1]) == "table" then
      section[1].separator = separators
    end
  end

  modify_section(modified_config.sections.lualine_a, "left")
  modify_section(modified_config.sections.lualine_z, "right")

  return modified_config
end

---Determines the formatters that will run against the current buffer.
---
---If there aren't any configured formatters for the current buffer *but* an LSP formatter
---is available, `"LSP"` will be returned.
---
---If there are neither formatters nor LSPs configured for the current buffer, the component
---will be hidden.
---@return string
local function formatter_status()
  local formatter_data, lsp_fallback = require("conform").list_formatters_to_run(0)
  local formatters = vim.iter(formatter_data):map(function(value) return value.name end):totable()

  if lsp_fallback then
    table.insert(formatters, "LSP")
  end

  return table.concat(formatters, ", ")
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
        separator = left_edge_separators,
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
          modified = utils.icons.unsaved,
          readonly = utils.icons.lock,
        },
      },
      {
        "grapple",
        color = function()
          local current_scope = require("grapple").app():current_scope().name

          if current_scope == "global" then
            return { fg = colors.red }
          elseif current_scope == "cwd" then
            return { fg = colors.green1 }
          elseif current_scope == "git_branch" then
            return { fg = colors.blue }
          elseif current_scope == "git" then
            return { fg = colors.orange }
          end

          return { fg = colors.blue } -- Default color
        end,
        cond = function() return not utils.Set({ "snacks_picker_input", "snacks_picker_list" })[vim.bo.filetype] end,
      },
    },
    lualine_x = {
      {
        "lsp_status",
        icon = { utils.icons.lsp, color = { fg = colors.blue1 } },
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
        icon = {
          utils.icons.formatting,
          color = function()
            local color = { fg = colors.yellow }
            if vim.b.disable_autoformat or vim.g.disable_autoformat then
              color.gui = "dim,italic"
            end
            return color
          end,
        },
        color = function()
          local gui = "dim,italic,strikethrough"
          if vim.g.disable_autoformat then
            return { fg = colors.red, gui = gui } -- Become red when disabled globally
          end
          if vim.b.disable_autoformat then
            return { gui = gui }
          end
        end,
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
        cond = function() return vim.diagnostic.is_enabled({ bufnr = 0 }) end,
      },
      {
        toggle_status,
        color = { fg = colors.green },
      },
    },
    lualine_y = {
      {
        "progress",
      },
    },
    lualine_z = {
      {
        "location",
        separator = right_edge_separators,
      },
    },
  },
  inactive_sections = {
    lualine_c = {
      {
        custom_filename,
        symbols = {
          modified = utils.icons.unsaved,
          readonly = utils.icons.lock,
        },
        colored = true,
        color = { fg = colors.fg_dark },
        separator = left_edge_separators,
      },
    },
    lualine_x = {
      {
        "location",
        colored = true,
        color = { fg = colors.fg_dark },
        separator = right_edge_separators,
      },
    },
  },
  extensions = {
    insert_edge_separators(require("lualine.extensions.quickfix")),
    insert_edge_separators(require("lualine.extensions.mason")),
    insert_edge_separators(require("lualine.extensions.man")),
    insert_edge_separators(require("lualine.extensions.oil")),
    insert_edge_separators(require("lualine.extensions.fugitive")),
    insert_edge_separators(help_extension),
  },
})
