require("paq")({
  -- self
  "https://github.com/savq/paq-nvim",
  -- Colorscheme
  "https://github.com/EdenEast/nightfox.nvim",
  "https://github.com/rose-pine/neovim",
  -- LuaLine
  "https://github.com/nvim-lualine/lualine.nvim",
  -- Language Server (LSP)
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/stevearc/aerial.nvim",
  -- Autocompletion
  {
    "https://github.com/Saghen/blink.cmp",
    build = "cargo build --release",
  },
  "https://github.com/folke/lazydev.nvim",

  -- Git
  "https://github.com/junegunn/gv.vim",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/tpope/vim-fugitive",
  "https://github.com/sindrets/diffview.nvim",
  -- Linters and Formatters
  "https://github.com/stevearc/conform.nvim",
  "https://github.com/mfussenegger/nvim-lint",
  "https://github.com/lukas-reineke/indent-blankline.nvim",
  -- Tree
  "https://github.com/nvim-tree/nvim-tree.lua.git",
  -- Tree Sitter
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/tronikelis/ts-autotag.nvim",
  --- REPL
  "https://github.com/pappasam/nvim-repl",
  -- ClaudeCode
  "https://github.com/greggh/claude-code.nvim",
  -- Other
  "https://github.com/kylechui/nvim-surround",
  "https://github.com/christoomey/vim-tmux-navigator",
  "https://github.com/mbbill/undotree",
  "https://github.com/j-hui/fidget.nvim",
  "https://github.com/chrishrb/gx.nvim",
  "https://github.com/echasnovski/mini.pairs",
  "https://github.com/catgoose/nvim-colorizer.lua",
  "https://github.com/sotte/presenting.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
  {
    "https://github.com/iamcco/markdown-preview.nvim",
    build = vim.fn["mkdp#util#install"],
  }
})

--------------------------------
--- Colors
-------------------------------
require("nightfox").setup({
  palettes = {
    all = {
      magenta = "#f681ba",
      green = "#52f0a0",
      red = "#ed7575",
    }
  },
})

vim.cmd([[colorscheme nightfox]])

-----------------------------------
----------------LSP CONFIG
----------------------------------
vim.lsp.handlers["window/showMessage"] = vim.lsp.handlers.notify

vim.lsp.enable("autotools_ls")
vim.lsp.enable("basedpyright")
vim.lsp.enable("bashls")
vim.lsp.enable("cssls")
vim.lsp.enable("dockerls")
vim.lsp.enable("docker_compose_language_service")
vim.lsp.enable("gh_actions_ls")
vim.lsp.enable("graphql")
vim.lsp.enable("harper_ls")
vim.lsp.enable("helm_ls")
vim.lsp.enable("html")
vim.lsp.enable("jsonls")
vim.lsp.enable("lua_ls")
vim.lsp.enable("marksman")
vim.lsp.enable("ruff")
vim.lsp.enable("taplo")
vim.lsp.enable("terraformls")
vim.lsp.enable("tflint")
vim.lsp.enable("ts_ls")
vim.lsp.enable("vimls")
vim.lsp.enable("yamlls")

vim.lsp.config("*", {
  capabilities = {
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = false, -- https://github.com/neovim/neovim/issues/23291
      },
    },
  },
})
vim.lsp.config("basedpyright", {
  settings = {
    basedpyright = {
      analysis = {
        diagnosticSeverityOverrides = {
          reportAny = false,
          reportDeprecated = false,
          reportExplicitAny = false,
          reportImplicitStringConcatenation = false,
          reportMissingParameterType = false,
          reportMissingTypeArgument = false,
          reportMissingTypeStubs = false,
          reportUnannotatedClassAttribute = false,
          reportUninitializedInstanceVariable = false,
          reportUnknownArgumentType = false,
          reportUnknownMemberType = false,
          reportUnknownParameterType = false,
          reportUnknownVariableType = false,
          reportUnnecessaryComparison = false,
          reportUnnecessaryIsInstance = false,
          reportUnusedCallResult = false,
          reportUnusedFunction = false,
          reportUnusedParameter = false,
        },
      },
    },
  },
})
vim.lsp.config("gh_actions_ls", {
  filetypes = { "yaml.github" },
  init_options = {
    -- Requires the `repo` and `workflow` scopes
    sessionToken = os.getenv("GITHUB_TOKEN"),
  },
})
vim.lsp.config("harper_ls", {
  settings = {
    ["harper-ls"] = {
      linters = {
        LongSentences = false,
        SentenceCapitalization = false,
        Spaces = false,
        SpellCheck = false,
        ToDoHyphen = false,
      },
    },
  },
})
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using
        -- (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {
          "vim",
          "require",
        },
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
        },
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
})
vim.lsp.config("yamlls", {
  filetypes = { "yaml" },
  settings = {
    yaml = {
      schemas = {
        kubernetes = "", -- disable built-in kubernetes support because we use specific version below
        ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.28.0-standalone/all.json"] =
        "*.k8s.yaml",
        ["https://raw.githubusercontent.com/compose-spec/compose-spec/refs/heads/main/schema/compose-spec.json"] = {
          "compose.yml",
          "compose.yaml",
        },
        ["http://json.schemastore.org/kustomization"] = "kustomization.yaml",
      },
      customTags = {
        "!ENV scalar",
        "!ENV sequence",
        "!relative scalar",
        "tag:yaml.org,2002:python/name:material.extensions.emoji.to_svg",
        "tag:yaml.org,2002:python/name:material.extensions.emoji.twemoji",
        "tag:yaml.org,2002:python/name:pymdownx.superfences.fence_code_format",
      },
      -- Add this to help with schema validation
      validate = true,
      -- This can help with schema conflicts
      schemaStore = {
        enable = false,
        url = "",
      },
    },
  },
})

-----------------------------------
----------------Treesitter
----------------------------------
---@diagnostic disable-next-line: missing-fields
require("nvim-treesitter.configs").setup({
  highlight = {
    enable = true,
    disable = function(lang, bufnr)
      if lang == "javascript" then
        return vim.api.nvim_buf_line_count(bufnr) > 10000
      end
      return vim.api.nvim_buf_line_count(bufnr) > 50000
    end,
  },
  indent = {
    enable = true,
    ---@diagnostic disable-next-line: unused-local
    disable = function(lang, bufnr)
      return vim.api.nvim_buf_line_count(bufnr) > 10000
    end,
  },
  ensure_installed = "all",
  ignore_install = { "ipkg" },
})

vim.treesitter.language.register("terraform", "terraform-vars")
vim.treesitter.language.register("bash", "zsh")
vim.treesitter.language.register("bash", "shell")

require("aerial").setup({})

---------------------------------------
---- Completion
-----------------------------------------
---@diagnostic disable-next-line: missing-fields
require("lazydev").setup({
  library = {
    -- Load luvit types when the `vim.uv` word is found
    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
  },
})
require("blink.cmp").setup({
  sources = {
    default = { "lazydev", "lsp", "path", "snippets", "buffer" },
    providers = {
      lazydev = {
        name = "LazyDev",
        module = "lazydev.integrations.blink",
        -- make lazydev completions top priority (see `:h blink.cmp`)
        score_offset = 100,
      },
    },
  },
  completion = {
    keyword = {
      range = "full",
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 500,
    },
    menu = {
      draw = {
        columns = {
          { "label",    "label_description", gap = 1 },
          { "kind_icon" },
          { "source_id" },
        },
      },
    },
  },
  cmdline = {
    enabled = false,
  },
})
---------------------------------------
---- Colorizer
---------------------------------------
require("colorizer").setup({
  filetypes = {
    "css",
    "kitty",
    "markdown",
    "typescriptreact",
    "vim",
    "yaml",
  },
})

-----------------------------------
---Pairs, Tags, Icons
----------------------------------
require("mini.pairs").setup({
  modes = { insert = true, command = true, terminal = false },
})
require("ts-autotag").setup({})
require("nvim-web-devicons").setup({
  default = true,
})

-----------------------------------
--- Tools
----------------------------------
require("fidget").setup({
  progress = {
    suppress_on_insert = true
  }
})

---@diagnostic disable-next-line: missing-fields
require("gx").setup({
  handlers = {
    pypi = {
      name = "pypi",
      filename = "pyproject.toml",
      handle = function(mode, line, _)
        -- Match poetry dependencies (name = "version")
        local pkg = require("gx.helper").find(line, mode, "([^=%s]+)%s-=%s")
        if pkg then
          return "https://pypi.org/project/" .. pkg
        end
        -- Match builtin dependencies list format ("name>=version" or "name")
        local dep_pkg =
            require("gx.helper").find(line, mode, '"([^>=%s"]+)[^"]*"')
        if dep_pkg then
          return "https://pypi.org/project/" .. dep_pkg
        end
      end,
    },
    ruff = {
      name = "ruff",
      filetypes = { "python" },
      handle = function(mode, line, _)
        local rule =
            require("gx.helper").find(line, mode, "# noqa: ([A-Z][0-9]+)")
        if rule then
          return "https://docs.astral.sh/ruff/rules/" .. rule
        end
      end,
    },
    npmjs = {
      name = "npmjs",
      filename = "package.json",
      handle = function(mode, line, _)
        local pkg = require("gx.helper").find(line, mode, '"([^"]+)":')
        if pkg then
          return "https://www.npmjs.com/package/" .. pkg
        end
      end,
    },
  },
})

require("presenting").setup({
  options = {
    width = 60,
  },
  separator = {
    markdown = "^##? ", -- # or ##, but not ###+
  },
  configure_slide_buffer = function(_)
    vim.cmd([[
      Fidget suppress
      setlocal buftype=nofile filetype=markdown bufhidden=wipe nomodifiable wrap conceallevel=3 concealcursor=nc
      nnoremap <buffer> q <Cmd>Presenting<CR>
      nnoremap <buffer> <C-w> <NOP>
      cnoreabbrev <buffer> q Presenting
      echo
    ]])
  end,
})

----------------------------
----GIT
---------------------------
require("gitsigns").setup({
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns
    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end
    -- Navigation
    map("n", "]c", function()
      if vim.wo.diff then
        return "]c"
      end
      vim.schedule(function()
        gs.next_hunk()
      end)
      return "<Ignore>"
    end, { expr = true })
    map("n", "[c", function()
      if vim.wo.diff then
        return "[c"
      end
      vim.schedule(function()
        gs.prev_hunk()
      end)
      return "<Ignore>"
    end, { expr = true })
    -- Actions
    map({ "n", "v" }, "<leader>hs", "<Cmd>Gitsigns stage_hunk<CR>")
    map({ "n", "v" }, "<leader>hr", "<Cmd>Gitsigns reset_hunk<CR>")
    map("n", "<leader>hS", gs.stage_buffer)
    map("n", "<leader>hu", gs.undo_stage_hunk)
    map("n", "<leader>hR", gs.reset_buffer)
    map("n", "<leader>hp", gs.preview_hunk)
    map("n", "<leader>hb", function()
      gs.blame_line({ full = true })
    end)
    map("n", "<leader>tb", gs.toggle_current_line_blame)
    map("n", "<leader>hd", gs.diffthis)
    map("n", "<leader>hD", function()
      gs.diffthis("~")
    end)
    map("n", "<leader>td", gs.toggle_deleted)
    -- Text object
    map({ "o", "x" }, "ih", "<Cmd>Gitsigns select_hunk<CR>")
  end,
})
require("diffview").setup({
  enhanced_diff_hl = true,
  show_help_hints = false,
  file_panel = {
    listing_style = "tree",
    win_config = {
      width = 30,
    },
  },
  hooks = {
    diff_buf_read = function(_)
      vim.opt_local.wrap = false
    end,
  },
})

----------------------------------------------------------------------
--- Tree
-----------------------------------------------------------------
require("nvim-tree").setup({
  renderer = {
    full_name = true,
    highlight_git = true,
    icons = {
      show = {
        git = true
      }
    }
  },
  actions = {
    change_dir = {
      global = true
    }
  },
  git = {
    enable = true
  },
  filters = {
    dotfiles = false,
  },
})


--------------------------
----Linterrs and Formatters
-----------------------------
require("ibl").setup({
  indent = { highlight = "IblIndent" },
})

require("conform").setup({
  formatters_by_ft = {
    javascript = { "prettier" },
    typescript = { "prettier" },
    javascriptreact = { "prettier" },
    typescriptreact = { "prettier" },
    svelte = { "prettier" },
    css = { "prettier" },
    html = { "prettier" },
    json = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },
    graphql = { "prettier" },
    lua = { "stylua" },
    python = { "isort", "black" },
    terraform = { "terraform_fmt" },
  },
  format_on_save = {
    lsp_fallback = true,
    async = false,
    timeout_ms = 1000,
  },
})


local lint = require("lint")
lint.linters_by_ft = {
  javascript = { "eslint_d" },
  typescript = { "eslint_d" },
  javascriptreact = { "eslint_d" },
  typescriptreact = { "eslint_d" },
  svelte = { "eslint_d" },
  python = { "pylint" },
  terraform = { "tflint" },
}

local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  group = lint_augroup,
  callback = function()
    lint.try_lint()
  end,
})


------------------------------------------------
---Lua Line
------------------------------------------a
require("lualine").setup({
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    always_show_tabline = true,
    globalstatus = false,
    refresh = {
      statusline = 100,
      tabline = 100,
      winbar = 100,
    }
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = { 'filename' },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
})

------------------------------------------------
---Claude Code
------------------------------------------a
require("claude-code").setup({
  -- Terminal window settings
  window = {
    split_ratio = 0.3,      -- Percentage of screen for the terminal window (height for horizontal, width for vertical splits)
    position = "botright",  -- Position of the window: "botright", "topleft", "vertical", "float", etc.
    enter_insert = true,    -- Whether to enter insert mode when opening Claude Code
    hide_numbers = true,    -- Hide line numbers in the terminal window
    hide_signcolumn = true, -- Hide the sign column in the terminal window

    -- Floating window configuration (only applies when position = "float")
    float = {
      width = "80%",       -- Width: number of columns or percentage string
      height = "80%",      -- Height: number of rows or percentage string
      row = "center",      -- Row position: number, "center", or percentage string
      col = "center",      -- Column position: number, "center", or percentage string
      relative = "editor", -- Relative to: "editor" or "cursor"
      border = "rounded",  -- Border style: "none", "single", "double", "rounded", "solid", "shadow"
    },
  },
  -- File refresh settings
  refresh = {
    enable = true,             -- Enable file change detection
    updatetime = 100,          -- updatetime when Claude Code is active (milliseconds)
    timer_interval = 1000,     -- How often to check for file changes (milliseconds)
    show_notifications = true, -- Show notification when files are reloaded
  },
  -- Git project settings
  git = {
    use_git_root = true, -- Set CWD to git root when opening Claude Code (if in git project)
  },
  -- Shell-specific settings
  shell = {
    separator = '&&',    -- Command separator used in shell commands
    pushd_cmd = 'pushd', -- Command to push directory onto stack (e.g., 'pushd' for bash/zsh, 'enter' for nushell)
    popd_cmd = 'popd',   -- Command to pop directory from stack (e.g., 'popd' for bash/zsh, 'exit' for nushell)
  },
  -- Command settings
  command = "claude", -- Command used to launch Claude Code
  -- Command variants
  command_variants = {
    -- Conversation management
    continue = "--continue", -- Resume the most recent conversation
    resume = "--resume",     -- Display an interactive conversation picker

    -- Output options
    verbose = "--verbose", -- Enable verbose logging with full turn-by-turn output
  },
  -- Keymaps
  keymaps = {
    toggle = {
      normal = "<leader>cc",     -- Normal mode keymap for toggling Claude Code, false to disable
      terminal = "<C-,>",        -- Terminal mode keymap for toggling Claude Code, false to disable
      variants = {
        continue = "<leader>cC", -- Normal mode keymap for Claude Code with continue flag
        verbose = "<leader>cV",  -- Normal mode keymap for Claude Code with verbose flag
      },
    },
    window_navigation = true, -- Enable window navigation keymaps (<C-h/j/k/l>)
    scrolling = true,         -- Enable scrolling keymaps (<C-f/b>) for page up/down
  }
})
