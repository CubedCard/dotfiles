#!/usr/bin/env bash
set -e

echo "==> Installing brew packages..."

# Terminal essentials
brew install neovim tmux starship fzf ripgrep fd

# Languages
brew install python go node openjdk
brew install --cask dotnet-sdk

# Web & search
brew install w3m ddgr tldr

# API & dev tools
brew install xh jq

# Shell plugins
brew install zsh-autosuggestions

echo "==> Running post-install setup..."

# fzf shell integration
"$(brew --prefix)/opt/fzf/install" --all --no-bash --no-fish

# Java: link into system JVM directory so /usr/libexec/java_home picks it up
sudo ln -sfn /opt/homebrew/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk

echo "==> Creating symlinks..."

mkdir -p ~/.config

ln -sf ~/dotfiles/tmux/.tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/starship/.config/starship.toml ~/.config/starship.toml
ln -sf ~/dotfiles/zshrc/.zshrc ~/.zshrc

# nvim: link the whole config directory
if [ -L ~/.config/nvim ]; then
    echo "     nvim symlink already exists, skipping"
else
    ln -sf ~/dotfiles/nvim/.config/nvim ~/.config/nvim
fi

# fastfetch: link the whole config directory
if [ -L ~/.config/fastfetch ]; then
    echo "     fastfetch symlink already exists, skipping"
else
    ln -sf ~/dotfiles/fastfetch/.config/fastfetch ~/.config/fastfetch
fi

echo ""
echo "Done! Next steps:"
echo "  1. Restart your shell or run: source ~/.zshrc"
echo "  2. Open nvim — lazy.nvim will install plugins automatically"
echo "  3. Run :MasonUpdate inside nvim to confirm all LSP servers are installed"
