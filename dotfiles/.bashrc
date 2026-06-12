#!/usr/bin/env bash
# ~/.bashrc — shared config sourced by both bash and zsh
# Shell-specific config belongs in .zshrc (or bash-guarded below)

################################################################
# ENV Vars
################################################################
export HISTSIZE=5000
export HISTFILE=~/.zsh_history
export SAVEHIST=5000
export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"
export KUBECTL_EXTERNAL_DIFF="colordiff -N -u"
export EDITOR='nvim'
export ALACRITTY_BACKGROUND_CACHE_FILE="$HOME/.cache/alacritty/background.toml"
export TMUX_CONFIGURE_OPTIONS=--enable-sixel
export BROWSER=/usr/bin/firefox
export LS_COLORS='di=1;34:fi=0:ln=1;36:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=1;92:*.rpm=90'
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export GOOGLE_APPLICATION_CREDENTIALS="$HOME/.config/gcloud/application_default_credentials.json"
export GOOGLE_REGION=us-east1
export AWS_REGION=us-east-1

################################################################
# Claude Code
################################################################
function claude-work() {
  export CLAUDE_CODE_USE_BEDROCK=1
  export CLAUDE_CODE_MAX_OUTPUT_TOKENS=8192
  export ANTHROPIC_MODEL=arn:aws:bedrock:us-east-1:961517735772:application-inference-profile/s579g2wiitpl
  export ANTHROPIC_DEFAULT_OPUS_MODEL=arn:aws:bedrock:us-east-1:961517735772:application-inference-profile/s579g2wiitpl
  export ANTHROPIC_DEFAULT_SONNET_MODEL=arn:aws:bedrock:us-east-1:961517735772:application-inference-profile/72u7r1j3vqhh
  export ANTHROPIC_DEFAULT_HAIKU_MODEL=arn:aws:bedrock:us-east-1:961517735772:application-inference-profile/pv9xb2ssxwl3
}

function claude-personal() {
  unset CLAUDE_CODE_USE_BEDROCK
  unset ANTHROPIC_MODEL
  unset ANTHROPIC_DEFAULT_OPUS_MODEL
  unset ANTHROPIC_DEFAULT_SONNET_MODEL
  unset ANTHROPIC_DEFAULT_HAIKU_MODEL
  unset CLAUDE_CODE_SUBAGENT_MODEL
  unset CLAUDE_CODE_MAX_OUTPUT_TOKENS
  echo "Claude Code: using Claude Pro (personal)"
}

claude-work

################################################################
# PATH
################################################################
function rm_from_path() {
  PATH=$(echo "$PATH" | tr ':' '\n' | grep -v "^${1}$" | tr '\n' ':' | sed 's/:$//')
}
function path_ladd() {
  rm_from_path "$1"
  PATH="$1${PATH:+":$PATH"}"
}
function path_radd() {
  rm_from_path "$1"
  PATH="${PATH:+"$PATH:"}$1"
}

path_ladd "$HOME/.cargo/bin"
path_ladd "$HOME/.google-cloud-sdk/bin"
path_ladd "$HOME/.local/bin"
path_ladd "$HOME/bin"
path_ladd "$HOME/.bin"
path_ladd "$HOME/config/bin"
path_ladd "$HOME/go/bin"
export PATH

################################################################
# Sensitive
################################################################
if [[ -f "$HOME/.bash/sensitive" ]]; then
  source "$HOME/.bash/sensitive"
fi

################################################################
# ALIASES
################################################################

# VPN
alias kvpn="sudo nmcli c up aws"
alias svpn="sudo nmcli c down aws"
alias officevpn="sudo netExtender -u janderson@keplergrp.com -d LocalDomain svpn.keplergrp.com:4433"

# ls (lsd with fallback)
if command -v lsd &>/dev/null; then
  alias ls="lsd"
  alias sl='lsd'
  alias ll='lsd -lh'
  alias la='lsd -Alh'
else
  alias sl='ls'
  alias ll='ls -alFh'
  alias la='ls -Alh'
fi

# cat -> bat
if command -v bat &>/dev/null; then
  alias cat="bat"
fi

alias mkdir='mkdir -p'
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'

# Shell config
alias zo='source ~/.zshrc'
alias bashrc='nvim $HOME/.bashrc'
alias zshrc='nvim $HOME/.zshrc'
alias vimrc='nvim $XDG_CONFIG_HOME/nvim/init.lua'
alias tmuxconf='nvim $XDG_CONFIG_HOME/tmux/tmux.conf'

# Python
alias ve='python3 -m venv venv'
alias va='source venv/bin/activate'
alias python='python3'
alias deact='deactivate'

# Navigation
alias kip='cd ~/src/keplergroup'
alias kyu='cd ~/src/kyucollective'

# Tmux
alias tmux='tmux -2 -f ~/.config/tmux/tmux.conf'
alias smux='tmuxinator start kepler'
alias kmux='tmuxinator start kyu'
alias dmux='tmuxinator stop kepler'
alias bmux='tmuxinator stop kyu'

# Editor
alias vim="NVIM_APPNAME=nvim nvim"
alias f="nvim"

# Grep / search
alias rgh="rg --hidden"

# Git / GitHub
alias vgit='echo $VAULT_AUTH_GITHUB_TOKEN | pbcopy'
alias ggit='echo $TF_VAR_github_token | pbcopy'
alias eget='echo "961517735772.dkr.ecr.us-east-1.amazonaws.com" | pbcopy'
alias ghview="gh repo view -w"
alias prlist="gh pr list"
alias prstatus="gh pr status"
alias ghalint="actionlint -config-file ~/config/dotfiles/actionlint.yaml"
alias ghastatus="gh api -H 'Accept: application/vnd.github+json' -H 'X-GitHub-Api-Version: 2022-11-28' /orgs/keplergroup/actions/runners | jq -C '.runners[] | select(.status == \"online\") | {name, busy}'"

# Terraform
alias tfrm='terraform state rm '
alias tfmv='terraform state mv '
alias tflist='terraform state list'
alias tup='rm -rf .terraform && rm .terraform.lock.hcl && echo "1.10.2" > .terraform-version'
alias goterr='cd ~/src/keplergroup/kepler-terraform'
alias tamer='cd ~/src/keplergroup/kepler-terraform/aws/kepler_amer'
alias temea='cd ~/src/keplergroup/kepler-terraform/aws/kepler_emea_apac'
alias gomod='cd ~/src/keplergroup/kepler-terraform-modules'

# Kubernetes
alias kargo="kubectl config use-context argo"

# AWS / Argo
alias awho="aws sts get-caller-identity"
alias argolog="argocd login argocd.keplergrp.com --sso"
alias awslog="aws sso login"

# Cookiecutters
alias cookies3="cookiecutter git@github.com:keplergroup/cookiecutter-terraform-s3-bucket.git"
alias cookieci="cookiecutter git@github.com:keplergroup/cookiecutter-gha-ci-pipeline.git"
alias cookiepack="cookiecutter git@github.com:keplergroup/cookiecutter-gha-ci-packages.git"
alias cookiek8s="cookiecutter git@github.com:keplergroup/cookiecutter-k8s-deployment.git"

################################################################
# FUNCTIONS
################################################################
function eg() {
  local pattern="${1:?usage: eg <pattern>}"
  local results
  results=$(env | awk -F= -v pat="$pattern" 'tolower($1) ~ tolower(pat)' | sort)
  if [[ -z "$results" ]]; then
    echo "eg: no matches for '$pattern'" >&2
    return 1
  fi
  echo "$results" | grep -i --color=always "$pattern"
}

function klone() {
  if [[ ! -d ~/src/$1 ]]; then
    git clone "git@github.com:$1.git" "$HOME/src/$1"
  else
    echo "Repo is already kloned!"
  fi
}

function td() {
  local dir
  dir=$(git rev-parse --show-toplevel 2>/dev/null) || { echo "Not in a git repo"; return 1; }
  cd "$dir"
}

function prview() {
  if [[ -z "$1" ]]; then
    echo "Need a PR number supplied!"
    return 1
  elif [[ "$2" == "web" ]]; then
    gh pr view "$1" -w
  else
    gh pr view "$1" --comments
  fi
}

function prco() {
  if [[ -z "$1" ]]; then
    echo "Need a PR number supplied!"
    return 1
  fi
  gh pr checkout "$1"
}

function prcreate() {
  if [[ -z "$1" ]]; then
    gh pr create
  else
    gh pr create -B "$1"
  fi
}

function update_program() {
  case $1 in
    zoom)
      curl -Lsf https://zoom.us/client/latest/zoom_amd64.deb -o /tmp/zoom_amd64.deb
      sudo dpkg -i /tmp/zoom_amd64.deb
      ;;
    vault)
      if [[ -z "$2" ]]; then
        echo "Missing Vault version!"
      else
        curl -Lsf "https://releases.hashicorp.com/vault/${2}/vault_${2}_linux_amd64.zip" -o /tmp/vault.zip
        unzip -o -d "$HOME/.local/bin/" /tmp/vault.zip
        echo "Updated Vault to $2"
      fi
      ;;
  esac
}

function aw() {
  assume -c -s "$2" "$1"
}

function upgrade() {
  sudo apt update
  sudo apt upgrade -y
  sudo apt autoremove -y
  sudo snap refresh
  mise self-update -y
  mise upgrade -y
  mise install -y
}

function k() { kubectl "$@"; }
function kuse() { kubectl config use-context "$1"; }

function c() { cd "$HOME/config/$1" || return; }

function switchenv() {
  local dir="$PWD"
  local env=$(echo "$dir" | sed "s|^.*/kepler-terraform/||" | cut -d / -f 3)
  local dir_prefix=$(echo "$dir" | awk -F "$env" '{print $1}')
  local dir_suffix=$(echo "$dir" | awk -F "$env" '{print $2}')
  local new_env
  if [[ "$env" == 'master' ]]; then
    new_env='integration'
  elif [[ "$env" == 'integration' ]]; then
    new_env='master'
  else
    new_env="${1:?usage: switchenv <environment>}"
  fi
  cd "${dir_prefix}${new_env}${dir_suffix}"
}

################################################################
# Bash-only (minimal prompt for script debugging)
################################################################
if [[ -n "$BASH" ]]; then
  COLOR_SILVER="\033[38;5;248m"
  COLOR_GOLD="\033[38;5;142m"
  COLOR_RESET="\033[0m"
  BOLD="$(tput bold)"
  PS1="\[$BOLD\]\[$COLOR_GOLD\]\u@\h \[\033[38;5;115m\]\w\[$COLOR_SILVER\]\$ \[$COLOR_RESET\]"
fi
