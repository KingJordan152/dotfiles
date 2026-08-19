---@type vim.lsp.Config
return {
  settings = {
    ["js/ts"] = {
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
