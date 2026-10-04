# shellcheck disable=SC1091

# Both shells get ~/.local/bin from the profile layer, so every child process
# inherits it instead of the rc layer re-deriving it.
export PATH="$HOME/.local/bin:$PATH"

# Where this repository lives.  Only needs XDG_DATA_HOME, which the entry files
# export before this file is sourced.
export DOTFILES="${XDG_DATA_HOME}/dotfiles"

# Redirect dotfile histories to XDG paths
export LESSHISTFILE="$XDG_STATE_HOME/less/history"
export NODE_REPL_HISTORY="$XDG_STATE_HOME/node/repl_history"
export SQLITE_HISTORY="$XDG_STATE_HOME/sqlite/history"
export WGET_HSTS="$XDG_CACHE_HOME/wget-hsts"

export EDITOR="nvim"

# starship
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"

# cargo
[ -s "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# NVM
export NVM_DIR="$XDG_DATA_HOME/nvm"

# Homebrew mirrors — macOS only.  Linux package managers are configured per
# machine in ~/.config/local/profile/.
if [ "$(uname -s)" = "Darwin" ]; then
  export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
  export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"
  export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
fi
