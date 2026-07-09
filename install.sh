#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
backup_suffix=".bak.$(date +%Y%m%d%H%M%S)"

backup_if_needed() {
  local target="$1"

  if [ -e "$target" ] || [ -L "$target" ]; then
    mv "$target" "${target}${backup_suffix}"
    printf 'Backed up %s to %s\n' "$target" "${target}${backup_suffix}"
  fi
}

link_path() {
  local source_path="$1"
  local target_path="$2"

  mkdir -p "$(dirname "$target_path")"

  if [ -L "$target_path" ] && [ "$(readlink "$target_path")" = "$source_path" ]; then
    printf 'Already linked: %s\n' "$target_path"
    return
  fi

  backup_if_needed "$target_path"
  ln -s "$source_path" "$target_path"
  printf 'Linked %s -> %s\n' "$target_path" "$source_path"
}

copy_path() {
  local source_path="$1"
  local target_path="$2"

  mkdir -p "$(dirname "$target_path")"

  if [ -f "$target_path" ] && cmp -s "$source_path" "$target_path"; then
    printf 'Already copied: %s\n' "$target_path"
    return
  fi

  backup_if_needed "$target_path"
  cp "$source_path" "$target_path"
  printf 'Copied %s -> %s\n' "$source_path" "$target_path"
}

ensure_oh_my_tmux() {
  if [ -f "$HOME/.tmux/.tmux.conf" ]; then
    return
  fi

  if [ -e "$HOME/.tmux" ] && [ ! -d "$HOME/.tmux/.git" ]; then
    printf 'Existing ~/.tmux is not a gpakosz/.tmux clone; install it manually first.\n' >&2
    exit 1
  fi

  git clone https://github.com/gpakosz/.tmux.git "$HOME/.tmux"
}

link_path "$repo_root/nvim" "$HOME/.config/nvim"
copy_path "$repo_root/ideavimrc" "$HOME/.ideavimrc"

ensure_oh_my_tmux
link_path "$HOME/.tmux/.tmux.conf" "$HOME/.tmux.conf"
link_path "$repo_root/tmux/tmux.conf.local" "$HOME/.tmux.conf.local"

printf '\nDone. Start a new tmux session and open nvim to let plugins install.\n'
