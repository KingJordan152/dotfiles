vim.pack.add({ "https://github.com/kylechui/nvim-surround" })

require("nvim-surround").setup({
  move_cursor = "sticky",
  surrounds = {
    -- Generics
    ["g"] = {
      add = function()
        local result = require("nvim-surround.config").get_input("Enter the generic type: ")
        if result then
          return { { result .. "<" }, { ">" } }
        end
      end,
      find = "%w+%b<>",
      delete = "^(%w+<)().-(>)()",
      change = {
        target = "^(%w+)().-()()",
        replacement = function()
          local result = require("nvim-surround.config").get_input("Enter the generic type: ")
          if result then
            return { { result }, { "" } }
          end
        end,
      },
      label = "Generic<...>",
    },
  },
})
