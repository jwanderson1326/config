# Amazon Q pre block. Keep at the top of this file.
[[ -f "${HOME}/.local/share/amazon-q/shell/bash_profile.pre.bash" ]] && builtin source "${HOME}/.local/share/amazon-q/shell/bash_profile.pre.bash"
export PATH=~/.local/bin:~/terraform:$PATH


export PATH="$HOME/.poetry/bin:$PATH"

export PATH="$HOME/.asdf/installs/poetry/1.0.5/bin:$PATH"

export PATH="$HOME/.asdf/installs/poetry/1.1.4/bin:$PATH"

export PATH="$HOME/.asdf/installs/poetry/1.0.0/bin:$PATH"

export PATH="$HOME/.asdf/installs/poetry/1.1.5/bin:$PATH"
. "$HOME/.cargo/env"

# Amazon Q post block. Keep at the bottom of this file.
[[ -f "${HOME}/.local/share/amazon-q/shell/bash_profile.post.bash" ]] && builtin source "${HOME}/.local/share/amazon-q/shell/bash_profile.post.bash"
