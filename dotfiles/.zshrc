# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/home/justin/.oh-my-zsh"


# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
 HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

###############################################################
#ZGEN SETTINGS
###############################################################
source "$HOME/.zgen/zgen.zsh"

if ! zgen saved; then
    zgen oh-my-zsh
    zgen oh-my-zsh plugins/git
    zgen oh-my-zsh plugins/aws
    zgen oh-my-zsh plugins/pyenv
    zgen oh-my-zsh plugins/terraform
    zgen load bhilburn/powerlevel9k powerlevel9k
    zgen save
fi


##############################################################
#THEME CONFIG
##############################################################
ZSH_THEME="powerlevel9k/powerlevel9k"

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



###############################################################
#SOURCING
##############################################################

source ~/.tmuxinator/completion/tmuxinator.zsh
export DISABLE_AUTO_TILE=true




# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#

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

######################################################################
#ALIASES
######################################################################


alias kvpn='sudo openvpn \
    --config ~/openvpn/openvpn.conf'

alias sl='ls'
alias ll='ls -alFh'
alias la='ls -Alfh'

alias pbcopy='xsel --clipboard --input'
alias pbcopy='xsel --clipboard --output'

alias zo='source ~/.zshrc'
alias ve='python3 -m venv venv'
alias va='source venv/bin/activate'
alias kip='cd ~/kepler-repos'
alias vgit='echo $VAULT_AUTH_GITHUB_TOKEN | pbcopy'
alias smux='mux start devops'
alias dmux='mux stop devops'
alias python='python3'
alias vim='nvim'
alias rg="rg --hidden"

alias goans='cd ~/kepler-repos/kepler-ansible'
alias goterr='cd ~/kepler-repos/kepler-terraform'
alias gomod='cd ~/kepler-repos/kepler-terraform-modules'
alias gopack='cd ~/kepler-repos/kepler-packer'


#Source sensitive files
if [ -f ~/.bash/sensitive ] ; then
    source ~/.bash/sensitive
fi

#Set EDITOR
export EDITOR='vim'

#Configure  pyenv path
PYENV_ROOT="$HOME/.pyenv"
if [ -d "$PYENV_ROOT" ]
then
    export PYENV_ROOT
    PATH="PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
fi

#Set PATH
TFENV_ROOT="$HOME/.tfenv/bin"
POETRY_ROOT="$HOME/.poetry/bin"

PATH=$PATH:$TFENV_ROOT:$POETRY_ROOT

NODENV_ROOT="$HOME/.nodenv"
if [ -d "$NODENV_ROOT" ]
then
  export NODENV_ROOT
  # Make sure it's not already in path
  if [[ ":$PATH:" != *":$NODENV_ROOT/bin:"* ]]
  then
    # If $PATH exists, then add $NODENV_ROOT to $PATH with : at the end;
    # otherwise NODENV_ROOT is the $PATH
    PATH="${PATH:+"$PATH:"}$NODENV_ROOT/bin"
    eval "$(nodenv init -)"
  fi
fi

NODE_MODULE_ROOT="$HOME/node_modules/bin"
PATH=$PATH:$NODE_MODULE_ROOT

fpath+=~/.zfunc

export PATH

typeset -aU path

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[[ -f /home/justin/.nodenv/versions/10.11.0/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh ]] && . /home/justin/.nodenv/versions/10.11.0/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[[ -f /home/justin/.nodenv/versions/10.11.0/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh ]] && . /home/justin/.nodenv/versions/10.11.0/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh
