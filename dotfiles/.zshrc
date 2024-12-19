##############################################################
# ENV Vars
################################################################
export HISTSIZE=5000
export HISTCONTROL=ignorespace
export HISTFILE=~/.zsh_history
export SAVEHIST=5000
export TF_PLUGIN_CACHE_DIR=/home/justin/.terraform.d/plugin-cache
export KUBECTL_EXTERNAL_DIFF="colordiff -N -u"
export EDITOR='nvim'
export ALACRITTY_BACKGROUND_CACHE_FILE="$HOME/.cache/alacritty/background.toml"
export TMUX_CONFIGURE_OPTIONS=--enable-sixel
export BROWSER=/usr/bin/firefox
export LS_COLORS='di=1;34:fi=0:ln=1;36:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=1;92:*.rpm=90'
export ALACRITTY_BACKGROUND_CACHE_FILE="$HOME/.cache/alacritty/background.toml"
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export GOOGLE_CLOUD_KEYFILE_JSON="~/.gcp/terraform_creds.json"
export GOOGLE_CREDENTIALS="~/.gcp/terraform_creds.json"
export GOOGLE_REGION=us-east1
export CARAPACE_BRIDGES=zsh,fish,bash,inshellisense

################################################################################
# SET OPTIONS
################################################################################
setopt AUTO_LIST
setopt LIST_AMBIGUOUS
setopt LIST_BEEP
setopt COMPLETE_ALIASES
setopt AUTOCD
setopt HIST_IGNORE_SPACE
setopt APPENDHISTORY
setopt SHAREHISTORY
setopt INCAPPENDHISTORY
unsetopt MENU_COMPLETE
unsetopt AUTO_REMOVE_SLASH

##############################################################
# Include
################################################################
function include() { [[ -f "$1" ]] && source "$1"; }
include "$HOME/.bash/sensitive"

#########################################################
# PATH
# #######################################################
function rm_from_path() { # $1: path to remove
  PATH=$(echo "$PATH" | tr ':' '\n' | grep -v "^${1}$" | tr '\n' ':' | sed 's/:$//')
}
function path_ladd() { # $1 path to add
  rm_from_path "$1"
  PATH="$1${PATH:+":$PATH"}"
}
function path_radd() { # $1 path to add
  rm_from_path "$1"
  PATH="${PATH:+"$PATH:"}$1"
}

path_ladd "$HOME/.cargo/bin"
path_ladd "$HOME/.google-cloud-sdk/bin"
path_ladd "$HOME/.local/bin"
path_ladd "$HOME/bin"
path_ladd "$HOME/.bin"
path_ladd "$HOME/config/bin"
export PATH

######################################################################
#ALIASES
######################################################################
alias kvpn="sudo nmcli c up aws"
alias svpn="sudo nmcli c down aws"

alias ls="lsd"
alias sl='lsd'
alias ll='lsd -lh'
alias la='lsd -Alh'
alias cat='bat'
alias mkdir='mkdir -p'

alias pbcopy='xsel --clipboard --input'

alias zo='source ~/.zshrc'
alias ve='python3 -m venv venv'
alias va='source venv/bin/activate'
alias kip='cd ~/src/kepler-repos'
alias vgit='echo $VAULT_AUTH_GITHUB_TOKEN | pbcopy'
alias ggit='echo $TF_VAR_github_token | pbcopy'
alias eget='echo "961517735772.dkr.ecr.us-east-1.amazonaws.com" | pbcopy'
alias tmux='tmux -2 -f ~/.config/tmux/tmux.conf'
alias smux='tmuxinator start devops'
alias dmux='tmuxinator stop devops'
alias python='python3'
alias vim="NVIM_APPNAME=nvim nvim"
alias rgh="rg --hidden"
alias f="nvim"
alias ghalint="actionlint -config-file ~/config/dotfiles/actionlint.yaml"
alias ghastatus="gh api -H 'Accept: application/vnd.github+json' -H 'X-GitHub-Api-Version: 2022-11-28' /orgs/keplergroup/actions/runners | jq -C '.runners[] | select(.status == \"online\") | {name, busy}'"

alias goterr='cd ~/src/kepler-repos/kepler-terraform'
alias tamer='cd ~/src/kepler-repos/kepler-terraform/aws/kepler_amer'
alias temea='cd ~/src/kepler-repos/kepler-terraform/aws/kepler_emea_apac'
alias gomod='cd ~/src/kepler-repos/kepler-terraform-modules'
alias officevpn="sudo netExtender -u janderson@keplergrp.com -d LocalDomain svpn.keplergrp.com:4433"
alias cookies3="cookiecutter git@github.com:keplergroup/cookiecutter-terraform-s3-bucket.git"
alias cookieci="cookiecutter git@github.com:keplergroup/cookiecutter-gha-ci-pipeline.git"
alias cookiepack="cookiecutter git@github.com:keplergroup/cookiecutter-gha-ci-packages.git"
alias cookiek8s="cookiecutter git@github.com:keplergroup/cookiecutter-k8s-deployment.git"

alias awho="aws sts get-caller-identity"

alias ghview="gh repo view -w"
alias prlist="gh pr list"
alias prstatus="gh pr status"

alias -g ...='../../'
alias -g ....='../../'
alias -g .....='../../../../'
alias -g ......='../../../../../'
alias -g .......='../../../../../../'
alias -g ........='../../../../../../../'
alias -g .........='../../../../../../../../'

alias tfrm='terraform state rm '
alias tfmv='terraform state mv '
alias tflist='terraform state list'
alias tup='rm -rf .terraform && rm .terraform.lock.hcl && echo "1.10.2" > .terraform-version'

alias kargo="kubectl config use-context argo"

###########################################################
# ZPLUG
# ##########################################################

if [ -f ~/.zplug/init.zsh ]; then
  source ~/.zplug/init.zsh

  zplug "paulirish/git-open", as:plugin
  zplug "greymd/docker-zsh-completion", as:plugin
  zplug "zsh-users/zsh-completions", as:plugin
  zplug "zsh-users/zsh-syntax-highlighting", as:plugin
  zplug "nobeans/zsh-sdkman", as:plugin
  zplug "junegunn/fzf", as:command, hook-build:"./install --bin", use:"bin/{fzf-tmux,fzf}"
  zplug "mdumitru/git-aliases", as:plugin

  zplug "romkatv/powerlevel10k", as:theme, depth:1

  # Install plugins if there are plugins that have not been installed
  if ! zplug check --verbose; then
      printf "Install? [y/N]: "
      if read -q; then
          echo; zplug install
      fi
  fi

  # Then, source plugins and add commands to $PATH
  zplug load
else
  echo "zplug not installed"
fi

#######################################################################
# fzf SETTINGS
#######################################################################

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

export FZF_DEFAULT_OPTS="--bind=ctrl-o:toggle-preview --ansi --preview 'bat {}' --preview-window hidden"
FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"' \
export FZF_DEFAULT_COMMAND

##############################################################
#THEME CONFIG
##############################################################
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

######################################
# Mise
# ###################################
if [[ $- == *i* ]]; then # interactive shell
  if [ -e "$HOME/.local/bin/mise" ]; then
    eval "$(~/.local/bin/mise activate zsh)"
  else
    echo 'Mise not installed, please install. See:'
    echo 'https://mise.jdx.dev/getting-started.html'
  fi
fi

################################################################################
# ZShell Auto Completion
################################################################################
fpath=(${ASDF_DIR}/completions /usr/local/share/zsh-completions $fpath $HOME/.zfunc)
autoload compinit
for dump in ~/.zcompdump(N.mh+24); do
  compinit
done
compinit -C
autoload -U +X bashcompinit && bashcompinit
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
zstyle ':completion:*' menu select incremental
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
zstyle ':completion:*' matcher-list '' 'm:{a-z\-A-Z}={A-Z\_a-z}' 'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-A-Z}={A-Z\_a-z}' 'r:|?=** m:{a-z\-A-Z}={A-Z\_a-z}'

fpath=(/usr/local/share/zsh-completions $fpath)
zmodload -i zsh/complist

# Most additional completions
if command -v carapace > /dev/null; then # https://github.com/rsteube/carapace-bin
  source <(carapace _carapace) # https://carapace-sh.github.io/carapace-bin/completers.html
fi

# Note in Carapace
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

######################################################################
# FUNCTIONS
######################################################################

function klone() {
  if [[ ! -d ~/kepler-repos/$1 ]]; then
    git clone git@github.com:KeplerGroup/$1.git ~/src/kepler-repos/$1
  else
    echo "Repo is already kloned!"
  fi
}
function gstuff() {
  git add .
  git commit -m "Enabling APM Profiler"
  git push origin sc-256814/enable-profiler
  gh pr create --title "Enabling APM Profiler" --body "This enables the profiler in APM ST we can use it"
}

function switchenv() {
  # Switch only the environment in the CWD
  # Requires environment as an argument
  # Example: switchenv master
  DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
  ENV=$(echo ${DIR} | sed "s/^.*\/kepler-terraform\///" | cut -d / -f 3)
  DIR_PREFIX=$(echo $DIR | awk -F "${ENV}" '{print $1}')
  DIR_SUFFIX=$(echo $DIR | awk -F "${ENV}" '{print $2}')
  if [[ $ENV == 'master' ]]; then
    NEW_ENV='integration'
  elif [[ $ENV == 'integration' ]]; then
    NEW_ENV='master'
  else
    NEW_ENV=$1
  fi
  cd "$DIR_PREFIX/$NEW_ENV/$DIR_SUFFIX"
}

# cd to the current git root
function td() {
  local dir
  dir=`git rev-parse --show-toplevel`
  if [ $? -eq 0 ]; then
    cd "$dir"
    return 0
  else
    return 1
  fi
}

alias prlist="gh pr list"

function prview {
  if [ -z "$1" ]; then
    "Need a PR Number supplied!"
  elif [[ $2 == "web" ]]; then
    gh pr view $1 -w
  else
    gh pr view $1 --comments
  fi
}

function prco {
  if [ -z "$1" ]; then
    "Need a PR Number supplied!"
  else
    gh pr checkout $1
  fi
}

function prcreate {
  if [ -z "$1" ]; then
    gh pr create
  else
    gh pr create -B $1
  fi
}

function update_program() {
  case $1 in
    zoom)
      curl -Lsf https://zoom.us/client/latest/zoom_amd64.deb -o /tmp/zoom_amd64.deb
      sudo dpkg -i /tmp/zoom_amd64.deb
      ;;
    vault)
      if [ -z $2 ]; then
        echo "Missing Vault Version!"
      else
        curl -Lsf https://releases.hashicorp.com/vault/${2}/vault_${2}_linux_amd64.zip -o /tmp/vault.zip
        unzip -o -d $HOME/.local/bin/ /tmp/vault.zip
        echo "Updated Vault to $2"
      fi
      ;;
  esac
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

# Kubernetes Functions
function k { kubectl $* }
function kuse { kubectl config use-context $1 }

function c() { cd "$HOME/config/$1" || return; }
