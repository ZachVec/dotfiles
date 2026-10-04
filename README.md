# dotfiles

Shell and tool configuration for Linux and macOS, kept in one git repository
and projected into `$HOME` with symlinks.

## Install

```bash
git clone git@github.com:ZachVec/dotfiles.git \
  "${XDG_DATA_HOME:-$HOME/.local/share}/dotfiles"
"${XDG_DATA_HOME:-$HOME/.local/share}/dotfiles/install.sh"
```

`install.sh` initialises the `nvim` submodule, creates the symlinks, creates
`~/.config/local/`, and reports missing binaries with install hints. It moves
any file it has to displace to `<name>.bak.<timestamp>` and never deletes
anything. It is idempotent, so run it whenever you like.

Flags: `--dry-run` prints the links it would create without touching
anything, `--check` runs only the dependency check.

## Update

```bash
~/.local/share/dotfiles/update.sh
```

That is `git pull --ff-only`, then `git submodule update`, then
`install.sh`.

## Layout

The repository does not live in `~/.config`. It lives in
`${XDG_DATA_HOME:-~/.local/share}/dotfiles` and is projected into place:

```
home/<name>      ->  ~/.<name>
config/<entry>   ->  ~/.config/<entry>
```

`config/nvim` is a git submodule; `install.sh` initialises it before creating
the symlinks.

Nothing in the working tree starts with a dot, which is exactly why the shell
entry points are bridged by symlinks instead of being stored under their
dotted names.

## Machine-local configuration

Anything that is true of one host only — proxy host and port, mirrors,
tokens — goes in:

```
~/.config/local/profile/*.sh   exports, loaded at login
~/.config/local/rc/*.sh        aliases and functions, loaded per shell
```

These are loaded last, so they win over the repository's defaults, and they
are never tracked. `install.sh` only creates the empty directories.

## Dependencies

`zsh`, `tmux`, `nvim`, `starship`, `fzf`, `lazygit` and `git-lfs`.
`install.sh` reports which are missing and how to install them on your
platform.
