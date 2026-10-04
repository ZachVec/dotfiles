# shellcheck disable=SC1090
# Missing binaries are reported by `install.sh --check`; see apps.bash for why
# this stays silent.
if command -v starship &>/dev/null; then eval "$(starship init zsh)"; fi
if command -v fzf &>/dev/null; then source <(fzf --zsh); fi
