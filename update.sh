#!/usr/bin/env bash
# Pull the latest configuration and re-apply the symlinks.
set -euo pipefail

DOTFILES="${DOTFILES:-${XDG_DATA_HOME:-$HOME/.local/share}/dotfiles}"

git -C "$DOTFILES" pull --ff-only
git -C "$DOTFILES" submodule update --init --recursive
exec "$DOTFILES/install.sh"
