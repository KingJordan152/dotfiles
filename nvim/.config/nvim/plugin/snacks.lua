vim.pack.add({ "https://github.com/folke/snacks.nvim" })

require("snacks").setup({
  bigfile = {
    enabled = true,
  },
  -- Custom `vim.ui.input`
  input = {
    enabled = true,
  },
  image = {
    enabled = true,
    convert = {
      notify = false,
    },
  },
  -- Auto-highlight LSP references
  words = {
    enabled = true,
  },
  -- Add textobjects for selecting inner/outer scope (uses Treesitter)
  scope = {
    enabled = true,
  },
  -- Floating picker windows (like Telescope)
  picker = {
    enabled = true,
    ui_select = true, -- Custom `vim.ui.select`
    formatters = {
      file = {
        filename_first = true,
      },
    },
    sources = {
      explorer = {
        auto_close = true,
      },
      projects = {
        dev = { "~/Documents", "~/Projects" },
        filter = {
          paths = {
            ["/opt"] = false,
            ["~/.local/share"] = false,
          },
        },
      },
      smart = {
        filter = {
          cwd = true,
        },
        title = "Find File",
      },
      recent = {
        filter = {
          cwd = true,
        },
      },
      lsp_config = {
        configured = true,
        attached = true,
        title = "Attached LSPs",
        layout = "dropdown",
      },
    },
    win = {
      input = {
        keys = {
          ["<Esc>"] = { "close", mode = { "n", "i" } }, -- Don't enter Normal mode inside picker
          ["<m-/>"] = { "toggle_help_input", mode = "i" },
        },
      },
    },
  },
  terminal = {
    enabled = true,
    auto_close = false,
  },
  -- Cool central-hub page (like Alpha)
  dashboard = {
    enabled = true,
    sections = {
      { section = "header" },
      { section = "keys", gap = 1, padding = 1 },
    },
    preset = {
      ---@type snacks.dashboard.Item[]
      keys = {
        { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
        { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
        {
          icon = " ",
          key = "r",
          desc = "Recent Files",
          action = ":lua Snacks.dashboard.pick('oldfiles')",
        },
        {
          icon = " ",
          key = "p",
          desc = "Recent Projects",
          action = ":lua Snacks.dashboard.pick('projects')",
        },
        {
          icon = " ",
          key = "c",
          desc = "Config",
          action = ":e ~/.config/nvim/lua/options.lua",
        },
        { icon = " ", key = "q", desc = "Quit", action = ":qa" },
      },
      header = [[
       ████ ██████           █████      ██                     
      ███████████             █████                             
      █████████ ███████████████████ ███   ███████████   
     █████████  ███    █████████████ █████ ██████████████   
    █████████ ██████████ █████████ █████ █████ ████ █████   
  ███████████ ███    ███ █████████ █████ █████ ████ █████  
 ██████  █████████████████████ ████ █████ █████ ████ ██████]],
    },
  },
  -- Reorganize the statuscolumn and add clickable 'fold' icons
  statuscolumn = {
    enabled = true,
    folds = {
      open = true,
      git_hl = true,
    },
  },
})

-- (Dashboard) Pull up dashboard from anywhere
vim.keymap.set("n", "<leader><CR>", Snacks.dashboard.open, { desc = "Open Dashboard" })

-- Primary Pickers
vim.keymap.set("n", "<leader><space>", Snacks.picker.smart, { desc = "Find File" })
vim.keymap.set("n", "<leader>,", Snacks.picker.buffers, { desc = "View Buffers" })
vim.keymap.set("n", "<leader>/", Snacks.picker.grep, { desc = "Grep Files" })
vim.keymap.set("x", "<leader>/", Snacks.picker.grep_word, { desc = "Grep Selection" })
vim.keymap.set("n", "<leader>:", Snacks.picker.command_history, { desc = "View Command History" })
vim.keymap.set("n", "<leader>.", Snacks.picker.resume, { desc = "Resume Previous Picker" })
vim.keymap.set("n", "<leader>E", Snacks.picker.explorer, { desc = "Open file explorer [Snacks]" })

-- Git Pickers
vim.keymap.set("n", "<leader>gB", Snacks.picker.git_branches, { desc = "Branches" })
vim.keymap.set("n", "<leader>gl", Snacks.picker.git_log, { desc = "Log" })
vim.keymap.set("n", "<leader>gL", Snacks.picker.git_log_line, { desc = "Log Line" })
vim.keymap.set("n", "<leader>gf", Snacks.picker.git_log_file, { desc = "Log File" })
vim.keymap.set("n", "<leader>gs", Snacks.picker.git_status, { desc = "Status" })
vim.keymap.set("n", "<leader>gS", Snacks.picker.git_stash, { desc = "Stash" })

-- Search Pickers
vim.keymap.set("n", '<leader>s"', Snacks.picker.registers, { desc = "Registers" })
vim.keymap.set("n", "<leader>s/", Snacks.picker.search_history, { desc = "History" })
vim.keymap.set("n", "<leader>sa", Snacks.picker.autocmds, { desc = "Autocmds" })
vim.keymap.set(
  "n",
  "<leader>sC",
  function()
    Snacks.picker.colorschemes({
      layout = {
        preset = "vscode",
        hidden = {},
      },
    })
  end,
  { desc = "Colorschemes" }
)
vim.keymap.set("n", "<leader>sd", Snacks.picker.diagnostics_buffer, { desc = "Buffer Diagnostics" })
vim.keymap.set("n", "<leader>sD", Snacks.picker.diagnostics, { desc = "All Diagnostics" })
vim.keymap.set("n", "<leader>sh", Snacks.picker.help, { desc = "Help Pages" })
vim.keymap.set("n", "<leader>sH", Snacks.picker.highlights, { desc = "Highlights" })
vim.keymap.set("n", "<leader>si", Snacks.picker.icons, { desc = "Icons (Nerd Fonts, Emojis, etc.)" })
vim.keymap.set("n", "<leader>sj", Snacks.picker.jumps, { desc = "Jumps" })
vim.keymap.set("n", "<leader>sk", Snacks.picker.keymaps, { desc = "Keymaps" })
vim.keymap.set("n", "<leader>sl", Snacks.picker.loclist, { desc = "Location List" })
vim.keymap.set("n", "<leader>sL", Snacks.picker.lsp_config, { desc = "Attached LSPs" })
vim.keymap.set("n", "<leader>sm", Snacks.picker.marks, { desc = "Marks" })
vim.keymap.set("n", "<leader>sM", Snacks.picker.man, { desc = "Man Pages" })
vim.keymap.set("n", "<leader>sn", Snacks.picker.notifications, { desc = "Notifications" })
vim.keymap.set("n", "<leader>sp", Snacks.picker.projects, { desc = "Projects" })
vim.keymap.set("n", "<leader>sq", Snacks.picker.qflist, { desc = "Quickfix List" })
vim.keymap.set("n", "<leader>sr", Snacks.picker.recent, { desc = "Recent" })
vim.keymap.set("n", "<leader>ss", Snacks.picker.lsp_symbols, { desc = "LSP Symbols" })
vim.keymap.set("n", "<leader>sS", Snacks.picker.lsp_workspace_symbols, { desc = "LSP Workspace Symbols" })
vim.keymap.set("n", "<leader>su", Snacks.picker.undo, { desc = "Undo History" })

-- Terminal Keymaps (includes VS Code-inspired)
vim.keymap.set({ "n", "t" }, "<C-`>", Snacks.terminal.focus, { desc = "Toggle/focus terminal" })
vim.keymap.set({ "n", "t" }, "<C-S-`>", Snacks.terminal.open, { desc = "Open new terminal" })
vim.keymap.set("n", "<leader>Tt", Snacks.terminal.focus, { desc = "Toggle/focus terminal" })
vim.keymap.set("n", "<leader>TT", Snacks.terminal.open, { desc = "Open new terminal" })

-- Generic Toggles
Snacks.toggle.diagnostics({ name = "Diagnostics" }):map("<leader>td")
Snacks.toggle.option("spell", { name = "Spellcheck" }):map("<leader>ts")
Snacks.toggle.option("wrap", { name = "Wrap Long Lines" }):map("<leader>tw")
Snacks.toggle.option("list", { name = "List (Visible Whitespace)" }):map("<leader>tl")
Snacks.toggle
  .new({
    id = "globalstatus",
    name = "Global Statusline",
    get = function() return require("lualine").get_config().options.globalstatus end,
    set = function(state) return require("lualine").setup({ options = { globalstatus = state } }) end,
  })
  :map("<leader>tS")
Snacks.toggle
  .new({
    id = "diagnostics_virtual_text",
    name = "Diagnostics Virtual Text",
    get = function() return vim.diagnostic.config().virtual_text ~= false end,
    set = function(state)
      if state then
        -- Keep in sync with default in `diagnostics.lua`
        vim.diagnostic.config({
          virtual_text = { source = "if_many", spacing = 2 },
        })
      else
        vim.diagnostic.config({ virtual_text = false })
      end
    end,
  })
  :map("<leader>tv")

-- Format on Save Toggles (used by `Conform`)
Snacks.toggle
  .new({
    id = "format_on_save_buffer",
    name = "Format on Save (buffer)",
    get = function() return not vim.b.disable_autoformat end,
    set = function(state) vim.b.disable_autoformat = not state end,
  })
  :map("<leader>tf")
Snacks.toggle
  .new({
    id = "format_on_save",
    name = "Format on Save (global)",
    get = function() return not vim.g.disable_autoformat end,
    set = function(state) vim.g.disable_autoformat = not state end,
  })
  :map("<leader>tF")

-- LSP Toggles (overwrite the ones in `lsp.lua`)
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("snacks_lsp_toggles", {}),
  callback = function(event)
    local client = assert(vim.lsp.get_client_by_id(event.data.client_id))
    local buf = event.buf

    if client:supports_method("textDocument/inlayHint") then
      Snacks.toggle
        .new({
          id = "inlay_hints",
          name = "LSP Inlay Hints",
          get = vim.lsp.inlay_hint.is_enabled,
          set = function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end,
        })
        :map("<leader>th", { buf = buf })
    end

    if client:supports_method("textDocument/codeLens") then
      Snacks.toggle
        .new({
          id = "code_lens",
          name = "LSP Code Lens",
          get = vim.lsp.codelens.is_enabled,
          set = function()
            vim.lsp.get_clients()
            vim.lsp.codelens.enable(not vim.lsp.codelens.is_enabled())
          end,
        })
        :map("<leader>tx", { buf = buf })
    end
  end,
})
