vim.pack.add({ "https://github.com/stevearc/conform.nvim" })

-- ==== Helper Functions and Variables ====

local utils = require("utils")
local package_json = nil
local web_dev_formatters = {
  "oxfmt",
  "prettierd",
  "biome",
  "biome-organize-imports",
}

-- Only read `package.json` once during intial plugin load (non-blocking)
vim.schedule(function() package_json = utils.read_package_json() end)

---Runs the first available formatter given as an argument.
---You can use this function to run one formatter from a list first *then* another one.
---
---This code can be found on the [GitHub page](https://github.com/stevearc/conform.nvim/blob/master/doc/recipes.md#run-the-first-available-formatter-followed-by-more-formatters) for `conform.nvim`.
---@param bufnr integer The buffer this formatting will be applied to.
---@param ... string The formatters you want to attempt to run.
---@return string
local function first(bufnr, ...)
  local conform = require("conform")

  for i = 1, select("#", ...) do
    local formatter = select(i, ...)
    if conform.get_formatter_info(formatter, bufnr).available then
      return formatter
    end
  end

  return select(1, ...)
end

---Adds the `injected` formatter to a list of formatters.
---@param formatters string[] List of formatters to add `injected` to.
---@return string[]
local function add_injected(formatters) return vim.list_extend(formatters, { "injected" }) end

---Takes a list of formatters and filters out the ones that don't have a current
---working directory (i.e., a dedicated configuration file).
---
---This function makes it so that the `require_cwd` formatter option doesn't have to
---be applied globally.
---@param bufnr integer Current buffer index.
---@param formatters string[] List of formatters to filter.
---@return string[]
local function require_cwd(bufnr, formatters)
  local conform = require("conform")
  return vim.tbl_filter(function(formatter) return conform.get_formatter_info(formatter, bufnr).cwd ~= nil end, formatters)
end

---Takes a list of formatters and filters out the ones that aren't listed as a dependency in the
---user's `package.json` file.
---
---If a `package.json` file isn't found in the current working directory, **all** the formatters will
---be filtered out.
---@param _ integer Placeholder for the current buffer index.
---@param formatters string[] List of formatters to filter.
---@return string[]
local function require_package_json(_, formatters)
  -- Immediately filter out all formatters if there isn't a `package.json` file in the current working directory
  if not package_json then
    return {}
  end

  -- Certain dependencies should activate different or additional formatters
  local formatter_dependency_map = {
    prettierd = "prettier",
    biome = "@biomejs/biome",
    ["biome-organize-imports"] = "@biomejs/biome",
  }

  return vim.tbl_filter(function(formatter)
    formatter = formatter_dependency_map[formatter] or formatter
    return package_json.dependencies[formatter] or package_json.devDependencies[formatter]
  end, formatters)
end

---Determines the formatters that will be used for all web development filetypes.
---
---A formatter must be listed as a dependency in the user's `package.json` _and_ have an associated configuration
---file in order for it to be activated. Otherwise, fallback to LSP formatters.
---@param bufnr integer Current buffer index.
---@return string[]
local function web_dev_config(bufnr) return require_cwd(bufnr, require_package_json(bufnr, web_dev_formatters)) end

---Determines the formatters that will be used for all web development-adjacent filetypes
---(i.e., files that can reasonably be found both inside and outside web development projects).
---
---For these files, the `web_dev_config` is applied, but rather than falling back to the LSP when
---no formatters are applicable, default to the first available formatter on the user's system.
---
---This makes it so that filetypes like `Markdown` can still receive dedicated formatting even when
---they're outside a web development project.
---@param bufnr integer Current buffer index.
---@return string[]
local function web_dev_adjacent_config(bufnr)
  local config = web_dev_config(bufnr)

  if vim.tbl_isempty(config) then
    config = { first(bufnr, unpack(web_dev_formatters)) }
  end

  return config
end

-- ==== Plugin Config ====

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()" -- Ensures `conform` is used for formatting globally

require("conform").setup({
  formatters_by_ft = {
    -- Individual Languages
    lua = { "stylua" },
    rust = { "rustfmt" },
    go = { "goimports", "gofmt", stop_after_first = true },
    python = {
      -- To fix auto-fixable lint errors.
      "ruff_fix",
      -- To run the Ruff formatter.
      "ruff_format",
      -- To organize the imports.
      "ruff_organize_imports",
    },

    -- Web Dev
    html = web_dev_config,
    css = web_dev_config,
    scss = web_dev_config,
    less = web_dev_config,
    javascript = web_dev_config,
    typescript = web_dev_config,
    typescriptreact = web_dev_config,
    javascriptreact = web_dev_config,
    vue = web_dev_config,
    astro = web_dev_config,
    svelte = web_dev_config,

    -- Etc.
    json = web_dev_adjacent_config,
    jsonc = web_dev_adjacent_config,
    json5 = web_dev_adjacent_config,
    yaml = web_dev_adjacent_config,
    toml = web_dev_adjacent_config,
    markdown = function(bufnr) return add_injected(web_dev_adjacent_config(bufnr)) end,
    mdx = function(bufnr) return add_injected(web_dev_adjacent_config(bufnr)) end,
  },

  default_format_opts = {
    lsp_format = "fallback",
  },

  format_on_save = function(bufnr)
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end

    return { lsp_format = "fallback", timeout_ms = 500 }
  end,
})

-- ==== Keymaps ====

vim.keymap.set({ "n", "v" }, "<leader>f", function()
  require("conform").format({ async = false, timeout_ms = 500, lsp_format = "fallback" }, function(err)
    if not err then
      local mode = vim.api.nvim_get_mode().mode
      if vim.startswith(string.lower(mode), "v") then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
      end
    end
  end)
end, { desc = "Format code" })

-- ==== Autocmds ====

vim.api.nvim_create_autocmd("FileChangedShellPost", {
  desc = "Reread the user's package.json file whenever a dependency is installed or removed via `npm`",
  pattern = "package.json",
  group = vim.api.nvim_create_augroup("conform_reload_package_json", {}),
  callback = function() package_json = utils.read_package_json() end,
})
