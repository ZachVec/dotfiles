#!/usr/bin/env bash
# Project this repository into $HOME and ~/.config.
#
#   install.sh             link everything, then check dependencies
#   install.sh --dry-run   print what would happen, touch nothing
#   install.sh --check     only run the dependency check
#
# Conflicting files are moved aside to <name>.bak.<timestamp>.  Nothing is
# ever deleted, and the script is safe to run repeatedly.
set -euo pipefail

DOTFILES="${DOTFILES:-${XDG_DATA_HOME:-$HOME/.local/share}/dotfiles}"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

DRY_RUN=0
CHECK_ONLY=0
case "${1:-}" in
  "")        ;;
  --dry-run) DRY_RUN=1 ;;
  --check)   CHECK_ONLY=1 ;;
  -h|--help) sed -n '2,9p' "$0"; exit 0 ;;
  *) echo "install.sh: unknown argument: $1" >&2; exit 2 ;;
esac

info() { printf '==> %s\n' "$*"; }
warn() { printf 'WARN: %s\n' "$*" >&2; }

# ── dependencies ───────────────────────────────────────────────────────────
REQUIRED="zsh tmux nvim starship fzf lazygit git-lfs"

pkg_hint() {
  if [ "$(uname -s)" = "Darwin" ]; then
    echo "brew install $1"
    return
  fi
  case "$1" in
    nvim)     echo "apt has an outdated build; https://github.com/neovim/neovim/blob/master/INSTALL.md" ;;
    starship) echo "curl -sS https://starship.rs/install.sh | sh" ;;
    lazygit)  echo "not in apt; https://github.com/jesseduffield/lazygit#installation" ;;
    fzf)      echo "apt's build is old; https://github.com/junegunn/fzf#installation" ;;
    git-lfs)  echo "apt install git-lfs" ;;
    *)        echo "apt install $1" ;;
  esac
}

check_deps() {
  local missing="" bin
  for bin in $REQUIRED; do
    command -v "$bin" >/dev/null 2>&1 || missing="$missing $bin"
  done
  if [ -z "$missing" ]; then
    info "all dependencies present"
    return 0
  fi
  warn "missing dependencies:$missing"
  for bin in $missing; do
    printf '  %-9s %s\n' "$bin" "$(pkg_hint "$bin")"
  done
}

# ── linking ────────────────────────────────────────────────────────────────
link() {
  local rel="$1" dst="$2" src="$DOTFILES/$1"
  if [ ! -e "$src" ]; then
    warn "source missing, skipped: $src"
    return 0
  fi
  if [ -L "$dst" ] && [ "$dst" -ef "$src" ]; then
    return 0
  fi
  if [ "$DRY_RUN" = 1 ]; then
    printf 'link  %s -> %s\n' "$dst" "$src"
    return 0
  fi
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    local backup="$dst.bak.$(date +%s)"
    mv "$dst" "$backup"
    warn "backed up $dst -> $backup"
  fi
  mkdir -p "$(dirname "$dst")"
  ln -sfn "$src" "$dst"
  printf 'link  %s -> %s\n' "$dst" "$src"
}

main() {
  if [ "$CHECK_ONLY" = 1 ]; then
    check_deps
    return 0
  fi
  if [ ! -d "$DOTFILES" ]; then
    echo "install.sh: repository not found at $DOTFILES (set DOTFILES)" >&2
    exit 1
  fi

  if [ "$DRY_RUN" = 0 ]; then
    git -C "$DOTFILES" submodule update --init --recursive
    mkdir -p "$CONFIG_HOME/local/profile" "$CONFIG_HOME/local/rc"
  fi

  # Shell entry points must keep their dotted names at $HOME, so the repo
  # stores them dotless and we bridge with symlinks.
  link home/zshenv       "$HOME/.zshenv"
  link home/zshrc        "$HOME/.zshrc"
  link home/bashrc       "$HOME/.bashrc"
  link home/bash_profile "$HOME/.bash_profile"

  # Every entry under config/ maps to ~/.config/<name>.
  local entry name
  for entry in "$DOTFILES"/config/*; do
    name="$(basename "$entry")"
    link "config/$name" "$CONFIG_HOME/$name"
  done

  if [ "$DRY_RUN" = 0 ]; then
    info "done"
    check_deps
  fi
}

main
