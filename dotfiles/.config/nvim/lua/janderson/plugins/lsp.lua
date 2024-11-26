return {
    {
        "VonHeikemen/lsp-zero.nvim",
        event = { "BufReadPre", "BufNewFile" },
        cmd = "Mason",
        branch = "v2.x",
        dependencies = {
            { "neovim/nvim-lspconfig" },
            {
                "williamboman/mason.nvim",
                build = function()
                    pcall(vim.cmd, "MasonUpdate")
                end,
            },
            { "williamboman/mason-lspconfig.nvim" },
            { "onsails/lspkind.nvim" },
            { "zbirenbaum/copilot-cmp" },
            { "hrsh7th/nvim-cmp" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "L3MON4D3/LuaSnip" },
            { "SmiteshP/nvim-navic" },
        },
        config = function()
            local lsp = require("lsp-zero").preset({})

            local navic = require("nvim-navic")

            lsp.on_attach(function(client, bufnr)
                lsp.default_keymaps({ buffer = bufnr })
                if client.server_capabilities.documentSymbolProvider then
                    navic.attach(client, bufnr)
                end
            end)
            require("mason").setup({})
            require("mason-lspconfig").setup({
                -- Replace the language servers listed here
                -- with the ones you want to install
                ensure_installed = {
                    "lua_ls",
                    "helm_ls",
                    "dockerls",
                    "marksman",
                    "pyright",
                    "terraformls",
                    "tflint",
                    "bashls",
                    "docker_compose_language_service",
                    "jsonls",
                    "jedi_language_server",
                    "ruff_lsp",
                    "rust_analyzer",
                    "yamlls",
                },
                handlers = {
                    lsp.default_setup,
                    -- lua_ls = {
                    -- 	Lua = {
                    -- 		runtime = {
                    -- 			-- Tell the language server which version of Lua you're using
                    -- 			-- (most likely LuaJIT in the case of Neovim)
                    -- 			version = "LuaJIT",
                    -- 		},
                    -- 		diagnostics = {
                    -- 			-- Get the language server to recognize the `vim` global
                    -- 			globals = {
                    -- 				"vim",
                    -- 				"require",
                    -- 			},
                    -- 		},
                    -- 		workspace = {
                    -- 			-- Make the server aware of Neovim runtime files
                    -- 			library = vim.api.nvim_get_runtime_file("", true),
                    -- 		},
                    -- 		-- Do not send telemetry data containing a randomized but unique identifier
                    -- 		telemetry = {
                    -- 			enable = false,
                    -- 		},
                    -- 	},
                    -- },
                },
            })

            lsp.setup()

            local cmp = require("cmp")
            -- local cmp_action = require('lsp-zero').cmp_action()

            require("luasnip.loaders.from_vscode").lazy_load()
            local lspkind = require("lspkind")
            lspkind.init({
                mode = 'symbol_text',

                -- default symbol map
                -- can be either 'default' (requires nerd-fonts font) or
                -- 'codicons' for codicon preset (requires vscode-codicons font)
                --
                -- default: 'default'
                preset = 'codicons',

                -- override preset symbols
                --
                -- default: {}
                symbol_map = {
                    Text = "󰉿",
                    Method = "󰆧",
                    Function = "󰊕",
                    Constructor = "",
                    Field = "󰜢",
                    Variable = "󰀫",
                    Class = "󰠱",
                    Interface = "",
                    Module = "",
                    Property = "󰜢",
                    Unit = "󰑭",
                    Value = "󰎠",
                    Enum = "",
                    Keyword = "󰌋",
                    Snippet = "",
                    Color = "󰏘",
                    File = "󰈙",
                    Reference = "󰈇",
                    Folder = "󰉋",
                    EnumMember = "",
                    Constant = "󰏿",
                    Struct = "󰙅",
                    Event = "",
                    Operator = "󰆕",
                    TypeParameter = "",
                    Copilot = "",
                },
            })

            vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })

            local has_words_before = function()
                if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
            end

            cmp.setup({
                preselect = cmp.PreselectMode.None,
                sources = {
                    -- Copilot Source
                    { name = "copilot",  group_index = 2 },
                    -- Other Sources
                    { name = "nvim_lsp", group_index = 2 },
                    { name = "path",     group_index = 2 },
                    { name = "luasnip",  group_index = 2 },
                },
                mapping = {
                    ["<CR>"] = cmp.mapping.confirm({ select = false }),
                    ["<Tab>"] = vim.schedule_wrap(function(fallback)
                        if cmp.visible() and has_words_before() then
                            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                        else
                            fallback()
                        end
                    end),
                },
                formatting = {
                    format = lspkind.cmp_format({
                        mode = 'symbol', -- show only symbol annotations
                        maxwidth = {
                            -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                            -- can also be a function to dynamically calculate max width such as
                            -- menu = function() return math.floor(0.45 * vim.o.columns) end,
                            menu = 50,            -- leading text (labelDetails)
                            abbr = 50,            -- actual suggestion item
                        },
                        ellipsis_char = '...',    -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
                        show_labelDetails = true, -- show labelDetails in menu. Disabled by default

                        -- The function below will be called before any actual modifications from lspkind
                        -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
                        before = function(entry, vim_item)
                            return vim_item
                        end
                    })
                }
                -- window = {
                --     completion = cmp.config.window.bordered(),
                --     documentation = cmp.config.window.bordered(),
                -- },
                -- snippet = {
                --     expand = function(args)
                --         require("luasnip").lsp_expand(args.body)
                --     end,
                -- },
            })
        end,
    },
    { "neovim/nvim-lspconfig" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/nvim-cmp" },
    { "L3MON4D3/LuaSnip" },
    { "onsails/lspkind.nvim" },
}
