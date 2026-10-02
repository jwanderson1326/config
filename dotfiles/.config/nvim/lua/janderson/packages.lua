require("paq")(require("janderson.plugins"))

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
-- Let servers learn about files changed on disk by other tools (AI agents,
-- git checkout, codegen) even when those files are not open in a buffer.
-- Without inotifywait Neovim falls back to a slow per-directory watcher, so
-- only enable it when inotify-tools is installed.
vim.lsp.config("*", {
  capabilities = {
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = vim.fn.executable("inotifywait") == 1,
      },
    },
  },
})

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
vim.lsp.config("terraformls", {
  cmd = { "terraform-ls", "serve", "-log-file=/tmp/terraform-ls-{{pid}}.log" },
  on_attach = function(client)
    client.server_capabilities.semanticTokensProvider = nil
  end,
})
vim.lsp.enable("tflint")
vim.lsp.enable("ts_ls")
vim.lsp.enable("vimls")
vim.lsp.enable("yamlls")

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
      -- `vim` globals and the runtime library come from lazydev.nvim
      workspace = {
        checkThirdParty = false,
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
-- nvim-treesitter `main` only installs parsers/queries; highlighting and
-- indentation are enabled per buffer below. `install` is a no-op for parsers
-- that are already present. Add languages here (`:TSInstall x` is temporary).
require("nvim-treesitter").install({
  "bash", "c", "css", "diff", "dockerfile", "git_config", "git_rebase",
  "gitattributes", "gitcommit", "gitignore", "go", "gomod", "graphql", "hcl",
  "helm", "html", "javascript", "jsdoc", "json", "lua", "luadoc", "make",
  "markdown", "markdown_inline", "python", "query", "regex", "rust", "sql",
  "terraform", "toml", "tsx", "typescript", "vim", "vimdoc", "yaml",
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
  callback = function(args)
    local lang = vim.treesitter.language.get_lang(args.match)
    if not lang then
      return
    end
    local lines = vim.api.nvim_buf_line_count(args.buf)
    if lines > (lang == "javascript" and 10000 or 50000) then
      return
    end
    if not pcall(vim.treesitter.start, args.buf, lang) then
      return -- no parser installed for this language
    end
    if lines <= 10000 and vim.treesitter.query.get(lang, "indents") then
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
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
require("fzf-lua").setup({
  actions = {
    files = {
      true, -- keep the default file actions
      -- alt-a: add the selected file(s) to Claude's context as @mentions
      ["alt-a"] = function(selected, opts)
        for _, entry in ipairs(selected) do
          local file = require("fzf-lua.path").entry_to_file(entry, opts)
          require("claudecode").send_at_mention(file.path)
        end
      end,
    },
  },
})
require("fzf-lua").register_ui_select()

require("which-key").setup({})
require("which-key").add({
  { "<leader>a", group = "AI / Claude" },
  { "<leader>f", group = "find" },
  { "<leader>g", group = "git" },
  { "<leader>h", group = "hunks" },
})

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
        vim.cmd.normal({ "]c", bang = true })
      else
        gs.nav_hunk("next")
      end
    end, { desc = "Next hunk" })
    map("n", "[c", function()
      if vim.wo.diff then
        vim.cmd.normal({ "[c", bang = true })
      else
        gs.nav_hunk("prev")
      end
    end, { desc = "Previous hunk" })
    -- Actions (stage_hunk on an already staged hunk unstages it)
    map({ "n", "v" }, "<leader>hs", "<Cmd>Gitsigns stage_hunk<CR>", { desc = "Stage/unstage hunk" })
    map({ "n", "v" }, "<leader>hr", "<Cmd>Gitsigns reset_hunk<CR>", { desc = "Reset hunk" })
    map("n", "<leader>hS", gs.stage_buffer, { desc = "Stage buffer" })
    map("n", "<leader>hR", gs.reset_buffer, { desc = "Reset buffer" })
    map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
    map("n", "<leader>hi", gs.preview_hunk_inline, { desc = "Preview hunk inline" })
    map("n", "<leader>hb", function()
      gs.blame_line({ full = true })
    end, { desc = "Blame line" })
    map("n", "<leader>ht", gs.toggle_current_line_blame, { desc = "Toggle line blame" })
    map("n", "<leader>hd", gs.diffthis, { desc = "Diff against index" })
    map("n", "<leader>hD", function()
      gs.diffthis("~")
    end, { desc = "Diff against HEAD~" })
    map("n", "<leader>hq", function()
      gs.setqflist("all")
    end, { desc = "All hunks to quickfix" })
    -- Text object
    map({ "o", "x" }, "ih", "<Cmd>Gitsigns select_hunk<CR>", { desc = "Hunk" })
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
  on_attach = function(bufnr)
    require("nvim-tree.api").config.mappings.default_on_attach(bufnr)
    vim.keymap.set("n", "<leader>as", "<Cmd>ClaudeCodeTreeAdd<CR>",
      { buffer = bufnr, desc = "Add file to Claude" })
  end,
})


--------------------------
----Linters and Formatters
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
    python = { "ruff_organize_imports", "ruff_format" },
    terraform = { "terraform_fmt" },
  },
  format_on_save = function(bufnr)
    -- Only format terraform files on save
    local filetype = vim.bo[bufnr].filetype
    if filetype == "terraform" then
      return {
        lsp_format = "fallback",
        async = false,
        timeout_ms = 1000,
      }
    end
  end,
})


local lint = require("lint")
lint.linters_by_ft = {
  javascript = { "eslint_d" },
  typescript = { "eslint_d" },
  javascriptreact = { "eslint_d" },
  typescriptreact = { "eslint_d" },
  svelte = { "eslint_d" },
  terraform = { "tflint" },
}

local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
  group = lint_augroup,
  callback = function()
    -- ignore_errors: don't warn on every buffer when e.g. eslint_d is missing
    lint.try_lint(nil, { ignore_errors = true })
  end,
})


------------------------------------------------
---Lua Line
------------------------------------------a
require("lualine").setup({
  options = {
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
  },
  sections = {
    lualine_x = {
      {
        function() return "󰚩 Claude" end,
        cond = function()
          local ok, claudecode = pcall(require, "claudecode")
          return ok and claudecode.is_claude_connected()
        end,
      },
      'encoding', 'fileformat', 'filetype',
    },
  },
  extensions = { "aerial", "fugitive", "nvim-tree", "quickfix" },
})
