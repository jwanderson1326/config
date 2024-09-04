require("nvim-tree").setup({
  renderer = {
    full_name = true,
    highlight_git = true,
    icons = {
        show  = {
          git = true
      }
    }
  },
  actions ={
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
