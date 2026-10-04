# AGENTS.md

Guidance for coding agents working on this repository.

## What this is

One user's shell and tool configuration for Linux and macOS. The repository is
not `~/.config`; it lives at `$XDG_DATA_HOME/dotfiles` (by default
`~/.local/share/dotfiles`) and `install.sh` projects it into place with
symlinks:

```
home/<name>      ->  $HOME/.<name>              file symlink
config/<entry>   ->  $XDG_CONFIG_HOME/<entry>   directory symlink
```

(`config/nvim` is a git submodule, so it is covered by the `config/` rule.)

No file in the working tree starts with a dot. `.gitignore`, `.gitmodules`
and the contents of `config/nvim/` are the only exceptions, and all three are
forced by git.

## Rules

- Everything the repo owns lives under `home/` or `config/`. Nothing else is
  symlinked anywhere.
- Adding a directory under `config/` needs no script change: the loop in
  `install.sh` links every entry it finds. Adding a file directly under
  `$HOME` needs a new `link` line in `install.sh`.
- The shell entry points are `home/zshenv`, `home/zshrc`, `home/bashrc` and
  `home/bash_profile`. There is no `ZDOTDIR`; zsh reads `~/.zshrc` directly.
- Machine-specific configuration never enters the repo. It goes in
  `~/.config/local/profile/*.sh` (exports, loaded at login) or
  `~/.config/local/rc/*.sh` (aliases and functions, loaded per shell).
  That mirrors the repo's own `sh/profile` and `sh/rc` split, and it loads
  last so it wins. `install.sh` creates those directories empty and they are
  never tracked.
- Differences that every machine of the same OS should share belong in the
  shared files behind a `[ "$(uname -s)" = Darwin ]` or `= Linux` test.
  Anything true of a single host belongs in `local/`.
- `install.sh` never deletes; it moves conflicts to `<name>.bak.<timestamp>`.
  Keep it idempotent and keep it free of network side effects.

## Layout

```
home/            shell entry points, symlinked to $HOME
config/          everything that belongs under ~/.config
  sh/            shared: profile/ (once per login), rc/ (every shell)
  zsh/           zsh-only modules
  bash/          bash-only modules
  git/           global git config and ignore file
  tmux/          tmux.conf, colorschemes/, scripts/
  nvim/          git submodule -> ZachVec/nvim-config (branch master)
  wezterm/ starship/ lazygit/ stylua.toml
install.sh       create/refresh symlinks, then report missing dependencies
update.sh        git pull + submodule update + install.sh
```

## How the shell loads

```
zsh:  ~/.zshenv       XDG vars, sh/profile, local/profile
      ~/.zshrc        sh/rc, zsh/*.zsh, local/rc
bash: ~/.bash_profile same profile layer, then chains to ~/.bashrc
      ~/.bashrc       sh/rc, bash/*.bash, local/rc
```

`profile/` runs once per login and `rc/` runs in every interactive shell.
Machine-local files load last, so they override anything from the repo.

The chain in `~/.bash_profile` is not optional.  For a login shell bash reads
exactly the first of `~/.bash_profile`, `~/.bash_login` and `~/.profile` that
exists, and never reads `~/.bashrc` on its own; zsh, by contrast, reads
`.zshrc` for every interactive shell without any help.  That same rule means a
`~/.profile` is silently ignored by bash once `~/.bash_profile` exists.
