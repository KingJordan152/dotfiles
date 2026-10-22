---@type vim.lsp.Config
return {
  settings = {
    ["js/ts"] = {
      format = {
        enabled = true,
      },
      referencesCodeLens = {
        enabled = false,
      },
      implementationsCodeLens = {
        enabled = false,
      },
      preferences = {
        preferTypeOnlyAutoImports = true,
      },
    },
  },
}
