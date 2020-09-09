############################################################
# ZPLUG
# ##########################################################

if [ -f ~/.zplug/init.zsh ]; then
  source ~/.zplug/init.zsh

  zplug "paulirish/git-open", as:plugin
  zplug "greymd/docker-zsh-completion", as:plugin
  zplug "zsh-users/zsh-completions", as:plugin
  zplug "zsh-users/zsh-syntax-highlighting", as:plugin
  zplug "nobeans/zsh-sdkman", as:plugin
  zplug "junegunn/fzf-bin", \
    from:gh-r, \
    as:command, \
    rename-to:fzf
  zplug "mdumitru/git-aliases", as:plugin

  zplug "romkatv/powerlevel10k", as:theme, depth:1
  #zplug "jwanderson1326/spaceship-prompt", use:spaceship.zsh, from:github, as:theme

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

##############################################################
#THEME CONFIG
##############################################################
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(virtualenv time context ssh dir vcs status)
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

# SPACESHIP_TIME_SHOW=true
# SPACESHIP_TIME_SUFFIX=' | '
# SPACESHIP_USER_SHOW=always
# SPACESHIP_USER_COLOR_ROOT=red
# SPACESHIP_USER_PREFIX=""
# SPACESHIP_USER_COLOR=white
# SPACESHIP_HOST_SHOW=true
# SPACESHIP_HOST_COLOR_SSH=green
# SPACESHIP_DIR_SHOW=true
# SPACESHIP_DIR_COLOR=81
# SPACESHIP_DIR_PREFIX="| "
# SPACESHIP_DIR_TRUNC_REPO=true
# SPACESHIP_DIR_TRUNC=3
# SPACESHIP_GIT_PREFIX=""
# SPACESHIP_GIT_BRANCH_COLOR=green
# SPACESHIP_GIT_STATUS_PREFIX=" "
# SPACESHIP_GIT_STATUS_SUFFIX=""
# SPACESHIP_GIT_STATUS_COLOR=green
# SPACESHIP_VENV_GENERIC_NAMES=()
# SPACESHIP_TERRAFORM_SHOW=true

# SPACESHIP_PROMPT_ORDER=(
#   battery
#   venv
#   time
#   user
#   host
#   dir
#   git
#   terraform
#   line_sep
#   line_sep
#   vpn
#   char
# )

################################################################################
# SET OPTIONS
################################################################################
setopt AUTO_LIST
setopt LIST_AMBIGUOUS
setopt LIST_BEEP

# completions
setopt COMPLETE_ALIASES

# automatically CD without typing cd
setopt AUTOCD

# Dealing with history
setopt HIST_IGNORE_SPACE
setopt APPENDHISTORY
setopt SHAREHISTORY
setopt INCAPPENDHISTORY
HIST_STAMPS="mm/dd/yyyy"

# History: How many lines of history to keep in memory
export HISTSIZE=5000

# History: ignore leading space, where to save history to disk
export HISTCONTROL=ignorespace
export HISTFILE=~/.zsh_history

# History: Number of history entries to save to disk
export SAVEHIST=5000

export TF_PLUGIN_CACHE_DIR=/home/justin/.terraform.d/plugin-cache

#######################################################################
# Unset options
#######################################################################

# do not automatically complete
unsetopt MENU_COMPLETE

# do not automatically remove the slash
unsetopt AUTO_REMOVE_SLASH

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


################################################################################
# LS_COLORS
################################################################################
LS_COLORS="di=1;34:"
#   fi  File
LS_COLORS+="fi=0:"
#   #   ln  Symbolic Link
LS_COLORS+="ln=1;36:"
#   #   pi  Fifo file
LS_COLORS+="pi=5:"
#   #   so  Socket file
LS_COLORS+="so=5:"
#   #   bd  Block (buffered) special file
LS_COLORS+="bd=5:"
#   #   cd  Character (unbuffered) special file
LS_COLORS+="cd=5:"
#   #   or  Symbolic Link pointing to a non-existent file (orphan)
LS_COLORS+="or=31:"
#   #   mi  Non-existent file pointed to by a symbolic link (visible with ls -l)
LS_COLORS+="mi=0:"
#   #   ex  File which is executable (ie. has 'x' set in permissions).
LS_COLORS+="ex=1;92:"
#   # additional file types as-defined by their extension
LS_COLORS+="*.rpm=90"
#
#   # Finally, export LS_COLORS
export LS_COLORS

################################################################################
# ZShell Auto Completion
################################################################################

autoload -U +X bashcompinit && bashcompinit
zstyle ':completion:*:*:git:*' script /usr/local/etc/bash_completion.d/git-completion.bash

# CURRENT STATE: does not select any sort of searching
# searching was too annoying and I didn't really use it
# If you want it back, use "search-backward" as an option
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"

# Fuzzy completion
zstyle ':completion:*' matcher-list '' \
  'm:{a-z\-A-Z}={A-Z\_a-z}' \
  'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-A-Z}={A-Z\_a-z}' \
  'r:|?=** m:{a-z\-A-Z}={A-Z\_a-z}'
fpath=(/usr/local/share/zsh-completions $fpath)
zmodload -i zsh/complist

# Manual libraries

# vault, by Hashicorp
_vault_complete() {
  local word completions
  word="$1"
  completions="$(vault --cmplt "${word}")"
  reply=( "${(ps:\n:)completions}" )
}
compctl -f -K _vault_complete vault

# stack
# eval "$(stack --bash-completion-script stack)"

# Add autocompletion path
fpath+=~/.zfunc



######################################################################
# FUNCTIONS
######################################################################

function klone() {
  if [[ ! -d ~/kepler-repos/$1 ]]; then
    git clone git@github.com:KeplerGroup/$1.git ~/kepler-repos/$1
  else
    echo "Repo is already kloned!"
  fi
}

function babs() {
  babel src/$1 --out-file=public/scripts/app.js --presets=env,react --watch
}



function dato() {
  PAYLOAD=$(jq -n \
    --arg user "$1" \
    --arg email "$2" \
    '{adhoc: true, username: $user, recipient: $email}')
  echo $PAYLOAD
  aws lambda invoke \
    --function-name kip-credential-rotater \
    --log-type Tail \
    --payload $PAYLOAD \
    /tmp/lambda.txt
}

function drmi() {
  for img in "$@"
  do
    docker image rm \
      $(docker images --format "{{.Repository}}:{{.Tag}}" | grep $img)
  done
}

function tf_syntax_update() {
  # This will fix maps to use TF 12's stricter syntax
  attribute=("tags" "vars" "default" "dimensions")
  for type in "${attribute[@]}"; do
    sed -i "s/${type}\ {/${type}\ =\ {/g" *.tf
  done
}


function tfpull {
  # This will pull a file down to /tmp/terraform
  terraform state pull > /tmp/terraform/$1.tfstate
}


function tfpush {
  # This will pull a file down to /tmp/terraform
  terraform state push /tmp/terraform/$1.tfstate
}

function switchenv() {
  # Switch only the environment in the CWD
  # Requires environment as an argument
  # Example: switchenv master
  DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
  ENV=$(echo ${DIR} | sed "s/^.*\/kepler-terraform\///" | cut -d / -f 1)
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

function gclean() {
  refs="$(git remote prune origin --dry-run)"
  if [ -z "$refs" ]
  then
    echo "No prunable references found"
  else
    echo $refs
    while true; do
     read yn\?"Do you wish to prune these local references to remote branches?"
     case $yn in
       [Yy]* ) break;;
       [Nn]* ) return;;
       * ) echo "Please answer yes or no.";;
     esac
    done
    git remote prune origin
    echo "Pruned!"
  fi

  local branches="$(git branch --merged master | grep -v '^[ *]*master$')"
  if [ -z "$branches" ]
  then
    echo "No merged branches found"
  else
    echo $branches
    while true; do
     read yn\?"Do you wish to delete these merged local branches?"
     case $yn in
       [Yy]* ) break;;
       [Nn]* ) return;;
       * ) echo "Please answer yes or no.";;
     esac
    done
    echo $branches | xargs git branch -d
    echo "Deleted!"
  fi
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

function prview {
  if [ -z "$1" ]; then
    "Need a PR Number supplied!"
  elif [[ $2 == "web" ]]; then
    gh pr view $1 -w
  else
    gh pr view $1
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
    kitty)
      curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
      ;;
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

function get_ips() {
  if [ -z "$1" ]; then
    echo "Must Define an Instance Name! eg mgmt-ecs-asg"
  else
    aws ec2 describe-instances --filters "Name=tag:Name,Values=$1" "Name=instance-state-name,Values=running" --query 'Reservations[*].Instances[*].{Instance:InstanceId,PrivateIP:PrivateIpAddress}' --output table
  fi
}

# REDSHIFT CONNECTIONS
function rs_analytics {
  vauth
  echo '---'
  local host="rs-analytics-master.keplergrp.com"
  local analytics_pw=$(vault read -field=password secret/administration/redshift/analytics-admin)
  PGPASSWORD=$analytics_pw FRIENDLY_HOSTNAME=$host psql -h $host -U kip -p 5439 -d kip
}

function rs_integration {
  vauth
  echo '---'
  local host="rs-analytics-integration.keplergrp.com"
  local integration_pw=$(vault read -field=password secret/administration/redshift/integration-analytics-admin)
  PGPASSWORD=$integration_pw FRIENDLY_HOSTNAME=$host psql -h $host -U kepleradmin -p 5439 -d kip
}

function rs_chubb {
  vauth
  echo '---'
  local host="rs-chubb-master.keplergrp.com"
  local chubb_pw=$(vault read -field=password secret/administration/redshift/chubb-admin)
  PGPASSWORD=$chubb_pw FRIENDLY_HOSTNAME=$host psql -h $host -U kepleradmin -p 5439 -d kepleradmin
}

function rs_sanofi {
  vauth
  echo '---'
  local host="rs-snfi-master.keplergrp.com"
  local snfi_pw=$(vault read -field=password secret/administration/redshift/sanofi-admin)
  PGPASSWORD=$snfi_pw FRIENDLY_HOSTNAME=$host psql -h $host -U kip_user -p 5439 -d kip
}

######################################################################
#ALIASES
######################################################################
alias kvpn="nmcli c up aws"
alias svpn="nmcli c down aws"

alias ovpn="sudo openvpn --config ~/openvpn/openvpn.conf"

alias sl='ls --color=auto'
alias ls='ls --color=auto'
alias ll='ls -alFh --color=auto'
alias la='ls -Alfh --color=auto'

alias pbcopy='xsel --clipboard --input'

alias zo='source ~/.zshrc'
alias ve='python3 -m venv venv'
alias va='source venv/bin/activate'
alias kip='cd ~/kepler-repos'
alias vgit='echo $VAULT_AUTH_GITHUB_TOKEN | pbcopy'
alias eget='echo "961517735772.dkr.ecr.us-east-1.amazonaws.com" | pbcopy'
alias tmux='tmux -2 -f ~/.tmux.conf'
alias smux='tmuxinator start devops'
alias dmux='tmuxinator stop devops'
alias python='python3'
alias vim='nvim'
alias rg="rg --hidden"
alias f="nvim"

alias goans='cd ~/kepler-repos/kepler-ansible'
alias goterr='cd ~/kepler-repos/kepler-terraform'
alias gomod='cd ~/kepler-repos/kepler-terraform-modules'
alias gopack='cd ~/kepler-repos/kepler-packer'
alias officevpn="sudo netExtender -u janderson@keplergrp.com -d LocalDomain svpn.keplergrp.com:4433"
alias homevpn="sudo openvpn --config ~/openvpn/janderson.ovpn"
alias cookies3="cookiecutter git@github.com:keplergroup/cookiecutter-terraform-s3-bucket.git"
alias cookieci="cookiecutter git@github.com:keplergroup/cookiecutter-ci-files.git"

alias indbabel='babel src/app.js --out-file=public/scripts/app.js --presets=env,react --watch'

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

################################################################
#Source sensitive files
################################################################

if [ -f ~/.bash/sensitive ] ; then
    source ~/.bash/sensitive
fi

################################################################
#Set EDITOR
################################################################
export EDITOR='vim'

###############################################################
# Set Google Cloud Creds Location
###############################################################
GOOGLE_CLOUD_KEYFILE_JSON="~/.gcp/terraform_creds.json"
GOOGLE_CREDENTIALS="~/.gcp/terraform_creds.json"
GOOGLE_REGION=us-east1

###############################################################
#Set PATH
###############################################################
POETRY_ROOT="$HOME/.poetry/bin"
RUST_ROOT="$HOME/.cargo/bin"
NODE_MODULE_ROOT="$HOME/node_modules/bin"
GCLOUD_ROOT="$HOME/.google-cloud-sdk/bin"

PATH=$PATH::$POETRY_ROOT:$RUST_ROOT:$NODE_MODULE_ROOTE:$GCLOUD_ROOT

fpath+=~/.zfunc

export PATH

typeset -aU path


[[ -f /home/justin/.nodenv/versions/10.11.0/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh ]] && . /home/justin/.nodenv/versions/10.11.0/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh
[[ -f /home/justin/.nodenv/versions/10.11.0/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh ]] && . /home/justin/.nodenv/versions/10.11.0/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh

# tabtab source for slss package
# uninstall by removing these lines or running `tabtab uninstall slss`
[[ -f /home/justin/node_modules/tabtab/.completions/slss.zsh ]] && . /home/justin/node_modules/tabtab/.completions/slss.zsh

. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash


# The next line enables shell command completion for gcloud.
if [ -f '/home/justin/.google-cloud-sdk/completion.zsh.inc' ]; then . '/home/justin/.google-cloud-sdk/completion.zsh.inc'; fi

### Temp

EFS_ID="fs-54f53f1d.efs.us-east-1.amazonaws.com"
