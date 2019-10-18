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
#ZSH_THEME="powerlevel9k/powerlevel9k"

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


###############################################################
#SOURCING
##############################################################

source ~/.tmuxinator/completion/tmuxinator.zsh
export DISABLE_AUTO_TILE=true



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
alias smux='mux start devops'
alias dmux='mux stop devops'
alias python='python3'
alias vim='nvim'
alias rg="rg --hidden"
alias f="nvim"

alias goans='cd ~/kepler-repos/kepler-ansible'
alias goterr='cd ~/kepler-repos/kepler-terraform'
alias gomod='cd ~/kepler-repos/kepler-terraform-modules'
alias gopack='cd ~/kepler-repos/kepler-packer'
alias officevpn="sudo netExtender -u janderson@keplergrp.com -d LocalDomain svpn.keplergrp.com:4433"
alias cookies3="cookiecutter git@github.com:keplergroup/cookiecutter-terraform-s3-bucket.git"
alias cookieci="cookiecutter git@github.com:keplergroup/cookiecutter-ci-files.git"

alias indbabel='babel src/app.js --out-file=public/scripts/app.js --presets=env,react --watch'

alias awho="aws sts get-caller-identity"


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
#Set PATH
###############################################################
POETRY_ROOT="$HOME/.poetry/bin"
RUST_ROOT="$HOME/.cargo/bin"
NODE_MODULE_ROOT="$HOME/node_modules/bin"

PATH=$PATH::$POETRY_ROOT:$RUST_ROOT:$NODE_MODULE_ROOTE

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
