---
name: dot
description: Manage the user's home-directory dotfiles, which are version-controlled in a bare git repository accessed via the `cfg` alias (NOT plain `git`). Use whenever working with tracked dotfiles in the home directory (e.g. ~/.zshrc, ~/.config/*), checking dotfile status/diffs, or committing and pushing config changes.
---

# Dotfiles (bare repo via `cfg`)

The user's home directory (`$HOME`) is managed as a **bare git repository** at `~/.dotfiles/`.
Do **not** use plain `git` for dotfile operations — the bare repo has no working tree of its own
and plain `git` in `$HOME` will target the wrong (or no) repository.

## The `cfg` alias

All dotfile version-control operations go through the `cfg` alias, defined in `~/.zshrc`:

```sh
alias cfg='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```

`cfg` is a drop-in replacement for `git` — every git subcommand works:

```sh
cfg status
cfg diff
cfg add ~/.zshrc
cfg commit -m "message"
cfg push
```

### Running `cfg` from a non-interactive shell

The `cfg` alias is only loaded in interactive shells, so it is **not** available in scripts or
in tools that run commands non-interactively (the alias will fail to expand). In those contexts,
define a shell function or expand the alias manually:

```sh
CFG() { git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" "$@"; }
CFG status
```

(Defining a function named `cfg` can collide with the existing alias in zsh — use a different
name like `CFG`, or run the full `git --git-dir=... --work-tree=...` command directly.)
