-- Build hook: updates all parsers when an update occurs
-- MUST be defined before `vim.pack.add` call.
vim.api.nvim_create_autocmd('PackChanged', { callback = function(ev)
  local name, kind = ev.data.spec.name, ev.data.kind
  if name == 'nvim-treesitter' and kind == 'update' then
    if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
    vim.cmd('TSUpdate')
  end
end })

vim.pack.add({ 'https://github.com/nvim-treesitter/nvim-treesitter' })

local ts = require("nvim-treesitter")

-- Ensure the following parsers are immediately installed
ts.install({
  "lua",
  "luadoc",
  "tsx",
  "typescript",
  "javascript",
  "jsdoc",
  "html",
  "css",
  "styled", -- For styled-components
  "markdown",
  "markdown_inline",
  "yaml",
  "regex", -- For certain pickers
  "latex",
  "query",
  "gitcommit",
  "c",
  "diff", -- For diff hover previews
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("treesitter.setup", {}),
  callback = function(args)
    local buf = args.buf
    local filetype = args.match
    local language = vim.treesitter.language.get_lang(filetype) or filetype

    -- Prevents Treesitter from running on buffers that don't correspond to an available language/parser
    if not vim.tbl_contains(ts.get_available(), language) then
      return
    end

    -- Auto-install a language; already installed languages are ignored
    ts.install(language):await(function()
      -- Enable highlighting
      vim.treesitter.start(buf, language)

      -- Enable folds
      vim.wo.foldmethod = "expr"
      vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"

      -- Enable indents
      vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end)
  end,
})
