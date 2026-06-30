# dotfiles

This repo tracks the machine-specific config you want to reuse on other machines:

- `nvim/`: your Neovim + LazyVim config
- `tmux/tmux.conf.local`: your local `oh-my-tmux` overrides

## Use on another machine

1. Clone this repo.
2. Run `./install.sh` from the repo root.
3. Start `nvim` once so LazyVim installs plugins.
4. Start a new `tmux` session.

## What `install.sh` does

- symlinks `nvim/` to `~/.config/nvim`
- clones `gpakosz/.tmux` into `~/.tmux` if needed
- symlinks `~/.tmux.conf` to `~/.tmux/.tmux.conf`
- symlinks `tmux/tmux.conf.local` to `~/.tmux.conf.local`

If an existing target file already exists, the script backs it up with a timestamped `.bak.*` suffix before replacing it.
