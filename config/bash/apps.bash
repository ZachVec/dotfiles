# shellcheck disable=SC1090,SC1091
# Missing binaries are reported by `install.sh --check`, so stay silent here.
# bash sources .bashrc for non-interactive shells started by sshd, and any
# echo would land inside that command's machine-readable output.
if command -v starship &>/dev/null; then eval "$(starship init bash)"; fi
if command -v fzf &>/dev/null; then source <(fzf --bash); fi
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
