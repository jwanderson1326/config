-- Plugin list for paq. Kept separate from the setup code in packages.lua so
-- plugins can be synced headless without running any setup():
--   nvim --headless -u NONE --cmd 'set rtp+=~/.local/share/nvim/site/pack/paqs/start/paq-nvim' \
--     -c 'lua require("paq")(dofile(vim.fn.stdpath("config") .. "/lua/janderson/plugins.lua"))' \
--     -c 'autocmd User PaqDoneSync quitall' -c PaqSync
return {
  -- self
  "https://github.com/savq/paq-nvim",
  -- Colorscheme
  "https://github.com/EdenEast/nightfox.nvim",
  -- LuaLine
  "https://github.com/nvim-lualine/lualine.nvim",
  -- Language Server (LSP)
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/stevearc/aerial.nvim",
  -- Autocompletion
  {
    -- paq has no semver support: pin a release tag so blink can download its
    -- prebuilt rust fuzzy matcher. Bump the tag by hand to upgrade.
    "https://github.com/Saghen/blink.cmp",
    branch = "v1.8.0",
    pin = true,
  },
  "https://github.com/folke/lazydev.nvim",
  -- Finder / keymap discovery
  "https://github.com/ibhagwan/fzf-lua",
  "https://github.com/folke/which-key.nvim",

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
  { "https://github.com/nvim-treesitter/nvim-treesitter", branch = "main", build = ":TSUpdate" },
  "https://github.com/tronikelis/ts-autotag.nvim",
  --- REPL
  "https://github.com/pappasam/nvim-repl",
  -- Claude Code (IDE integration: selection, diagnostics, native diffs)
  "https://github.com/coder/claudecode.nvim",
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
    build = function() vim.fn["mkdp#util#install"]() end,
  },
}
