# Amazon Q pre block. Keep at the top of this file.
[[ -f "${HOME}/.local/share/amazon-q/shell/zprofile.pre.zsh" ]] && builtin source "${HOME}/.local/share/amazon-q/shell/zprofile.pre.zsh"
export GOPATH="/usr/local/go/bin"
export PATH="$HOME/.cargo/bin:$GOPATH:$PATH"

export PATH="$HOME/.poetry/bin:$PATH"


export PATH="$HOME/.asdf/installs/poetry/1.0.5/bin:$PATH"

# Amazon Q post block. Keep at the bottom of this file.
[[ -f "${HOME}/.local/share/amazon-q/shell/zprofile.post.zsh" ]] && builtin source "${HOME}/.local/share/amazon-q/shell/zprofile.post.zsh"
