#!/bin/bash

packages=(
  fd
  ripgrep
)

modules=(
  nvim
  tmux
)

for package in "${packages[@]}"; do
  echo "Installing $package..."
  /home/linuxbrew/.linuxbrew/Homebrew install "$package"
done

for module in "${modules[@]}"; do
  echo "Stowing $module..."
  stow "$module"
done

echo "Dotfiles successfully installed!"
