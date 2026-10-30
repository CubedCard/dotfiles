#!/usr/bin/env bash
set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Installing pacman packages..."

sudo pacman -Syu --needed --noconfirm \
    zsh zsh-autosuggestions \
    neovim tmux starship fzf ripgrep fd fastfetch git base-devel \
    python go nodejs npm jdk-openjdk dotnet-sdk \
    w3m ddgr tldr xh jq

echo "==> Running post-install setup..."

# Java: make openjdk the default JVM
sudo archlinux-java set "$(archlinux-java status | awk '/openjdk/ {print $1; exit}')" || true

# Default shell (sudo avoids the interactive chsh password prompt)
if [ "$(getent passwd "$USER" | cut -d: -f7)" != "$(command -v zsh)" ]; then
    sudo chsh -s "$(command -v zsh)" "$USER"
fi

echo "==> Creating symlinks..."

mkdir -p ~/.config

# Replace an existing directory (e.g. Omarchy's default) with a symlink, keeping a backup
link_dir() {
    local src="$1" dest="$2"
    if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
        echo "     $dest already linked, skipping"
        return
    fi
    if [ -e "$dest" ] || [ -L "$dest" ]; then
        mv "$dest" "$dest.bak.$(date +%s)"
    fi
    ln -s "$src" "$dest"
}


# Omarchy ships ~/.config/tmux/tmux.conf, which is loaded after ~/.tmux.conf and overrides it
if [ -e ~/.config/tmux ] && [ ! -L ~/.config/tmux ]; then
    mv ~/.config/tmux ~/.config/tmux.bak.$(date +%s)
fi
ln -sf "$DOTFILES/tmux/.tmux.conf" ~/.tmux.conf
ln -sf "$DOTFILES/starship/.config/starship.toml" ~/.config/starship.toml
ln -sf "$DOTFILES/zshrc/.zshrc" ~/.zshrc

# nvim: link the whole config directory
link_dir "$DOTFILES/nvim/.config/nvim" ~/.config/nvim

# fastfetch: link the whole config directory
link_dir "$DOTFILES/fastfetch/.config/fastfetch" ~/.config/fastfetch

echo ""
echo "Done! Next steps:"
echo "  1. Install 'flip' (cubedcard/flip) manually; it was a Homebrew tap and isn't packaged for pacman"
echo "  2. Log out and back in so zsh becomes your login shell"
echo "  3. Open nvim — lazy.nvim will install plugins automatically"
echo "  4. Run :MasonUpdate inside nvim to confirm all LSP servers are installed"
