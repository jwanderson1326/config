# config

Personal dotfiles (Ubuntu, zsh, tmux, Neovim).

- `dotfiles/` mirrors `$HOME` and is linked in with GNU stow
  (`stow -d ~/config -t ~ dotfiles`). Editing `~/.config/nvim/...` edits this
  repo. `.bashrc` is currently a plain file in `$HOME`, not a link.
- `scripts/ubuntu/` holds machine bootstrap scripts (apt and custom installs).
- CLI tools and language runtimes are managed by mise:
  `dotfiles/.config/mise/config.toml`. Add tools there rather than through apt
  or npm -g.

## Neovim (`dotfiles/.config/nvim`)

Neovim nightly (0.12+). `init.vim` does `lua require("janderson")`, which loads,
in order:

| file | contents |
| --- | --- |
| `set.lua` | options, leader (`,`) |
| `remap.lua` | editor, picker (`<leader>f`) and git (`<leader>g`) keymaps |
| `indent.lua` | per-filetype deviations from ftplugin indent styles |
| `plugins.lua` | paq spec list only (no setup) |
| `packages.lua` | plugin setup: LSP, treesitter, blink, conform, lint, gitsigns, ... |
| `ai.lua` | claudecode.nvim, `<leader>a` keymaps, reload-on-disk-change |

- Plugins use paq-nvim (`~/.local/share/nvim/site/pack/paqs/start`). paq ignores
  lazy.nvim keys such as `version`; use `branch`/`pin`/`build`.
- LSP uses the native `vim.lsp.config`/`vim.lsp.enable` API, not lspconfig's
  `setup()`.
- nvim-treesitter is on the `main` branch (the rewrite): parsers are listed in
  `require("nvim-treesitter").install{...}`, and highlighting is started by a
  FileType autocmd. There is no `nvim-treesitter.configs`.
- Keep `desc` on every keymap; which-key displays them.

Checks that don't need an interactive session:

```sh
# config loads without errors
nvim --headless +qa
# inspect state, e.g. an option for a filetype
nvim --headless /tmp/x.go -c 'lua print(vim.bo.expandtab, vim.bo.shiftwidth)' +qa
# install/update/clean plugins from plugins.lua
nvim --headless -u NONE --cmd 'set rtp+=~/.local/share/nvim/site/pack/paqs/start/paq-nvim' \
  -c 'lua require("paq")(dofile(vim.fn.stdpath("config") .. "/lua/janderson/plugins.lua"))' \
  -c 'autocmd User PaqDoneSync quitall' -c PaqSync
```

The headless PaqSync skips build steps that need the full config (such as `:TSUpdate`);
run `nvim --headless +TSUpdate +qa` afterwards.

Format Lua with `stylua` (installed via mise).
