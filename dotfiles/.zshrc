# ~/.zshrc — zsh-specific config
# Shared env, PATH, aliases, and functions live in .bashrc

# Mise must activate before .bashrc so tools it manages (lsd, bat, etc.)
# are in PATH when .bashrc sets up aliases.
if [[ $- == *i* ]] && [[ -e "$HOME/.local/bin/mise" ]]; then
  eval "$(~/.local/bin/mise activate zsh)"
fi

source "$HOME/.bashrc"

################################################################################
# ZSH OPTIONS
################################################################################
setopt AUTO_LIST
setopt LIST_AMBIGUOUS
setopt LIST_BEEP
setopt AUTOCD
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
unsetopt MENU_COMPLETE
unsetopt AUTO_REMOVE_SLASH

################################################################################
# Global Aliases (zsh-only feature)
################################################################################
alias -g ...='../../'
alias -g ....='../../../'
alias -g .....='../../../../'
alias -g ......='../../../../../'
alias -g .......='../../../../../../'
alias -g ........='../../../../../../../'
alias -g .........='../../../../../../../../'

################################################################################
# ZPLUG
################################################################################
if [[ -f ~/.zplug/init.zsh ]]; then
  source ~/.zplug/init.zsh

  zplug "paulirish/git-open", as:plugin
  zplug "greymd/docker-zsh-completion", as:plugin
  zplug "zsh-users/zsh-completions", as:plugin
  zplug "zsh-users/zsh-syntax-highlighting", as:plugin
  zplug "nobeans/zsh-sdkman", as:plugin
  zplug "junegunn/fzf", as:command, hook-build:"./install --bin", use:"bin/{fzf-tmux,fzf}"
  zplug "mdumitru/git-aliases", as:plugin

  zplug "romkatv/powerlevel10k", as:theme, depth:1

  if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
      echo; zplug install
    fi
  fi

  zplug load
else
  echo "zplug not installed"
fi

################################################################################
# fzf
################################################################################
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

export FZF_DEFAULT_OPTS="--bind=ctrl-o:toggle-preview --ansi --preview 'bat {}' --preview-window hidden"
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'

source ~/.zplug/repos/junegunn/fzf/shell/key-bindings.zsh
source ~/.zplug/repos/junegunn/fzf/shell/completion.zsh

################################################################################
# Powerlevel10k Theme
################################################################################
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(kubecontext virtualenv time context ssh dir vcs status)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()
POWERLEVEL9K_DISABLE_RPROMPT=true
POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
POWERLEVEL9K_TIME_BACKGROUND='black'
POWERLEVEL9K_TIME_FOREGROUND='white'
POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND='123'
POWERLEVEL9K_DIR_HOME_BACKGROUND='123'
POWERLEVEL9K_VCS_CLEAN_BACKGROUND='048'
POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='227'
POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='210'
POWERLEVEL9K_KUBECONTEXT_BACKGROUND='31'

################################################################################
# Mise (activated early, before .bashrc — see top of file)
################################################################################
if ! command -v mise > /dev/null; then
  echo 'Mise not installed, please install. See:'
  echo 'https://mise.jdx.dev/getting-started.html'
fi

################################################################################
# Completions
################################################################################
zmodload -i zsh/complist

fpath=(/usr/local/share/zsh-completions $fpath $HOME/.zfunc)
autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
  compinit
done
compinit -C
autoload -U +X bashcompinit && bashcompinit

zstyle ':completion:*:*:*:*:*' menu select #: Use menu select instead of cycling
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|=*' 'l:|=* r:|=*'
#: Ignore some patterns when completing
zstyle ":completion:*" ignored-patterns "(*/)#(__pycache__|*.pyc|node_modules|.git|*.egg-info)"
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path $ZSH_CACHE_DIR
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories


# Carapace
export CARAPACE_BRIDGES=zsh
export CARAPACE_UNFILTERED=1
if command -v carapace > /dev/null; then
  source <(carapace _carapace)
fi

# Mise completions
if command -v mise > /dev/null; then
  eval "$(mise completions zsh)"
fi

# Vault
_vault_complete() {
  local word completions
  word="$1"
  completions="$(vault --cmplt "${word}")"
  reply=( "${(ps:\n:)completions}" )
}
compctl -f -K _vault_complete vault

################################################################################
# Shell integrations
################################################################################
eval "$(direnv hook zsh)"
eval "$(zoxide init zsh)"
