# Dotfiles

My dotfiles. I use Neovim for most of my programming tasks. For my general workflow I would use skhd, a shortcut tool, and amethyst, a window manager. These are some of the dotfiles present in this repository and I hope they could help anyone in the future.

## Setup

Run the install script to install all dependencies and create symlinks:

```bash
chmod +x install.sh && ./install.sh
```

## Tools

### Shell
- **zsh** + oh-my-zsh (plugins: git, zsh-autosuggestions, docker)
- **starship** — minimal prompt showing directory, git, and language versions
- **fzf** — fuzzy finder (`Ctrl+T` for files, `Ctrl+R` for history)
- **fd** — fast `find` replacement (used by fzf)
- **ripgrep** — fast `grep` replacement (used by telescope)

### Terminal
- **tmux** — session/window/pane management, prefix: `Ctrl+A`

### Editor — Neovim
Plugins managed by lazy.nvim:
- `blink.cmp` — completion
- `nvim-lspconfig` + `mason` — LSP (Python, Java, C#, Go, Bash, HTML, CSS, TS)
- `nvim-jdtls` — dedicated Java LSP integration
- `telescope.nvim` + fzf-native — fuzzy finding
- `harpoon` (v2) — fast file switching
- `conform.nvim` — formatting (black, gofmt, google-java-format, csharpier, shfmt)
- `kulala.nvim` — run HTTP requests from `.http` files
- `lualine` — statusline
- `gitsigns` — git change indicators in gutter
- `nvim-treesitter` — syntax highlighting
- `gruvbox` — colorscheme

### Languages installed
- Python (`brew install python` + pyenv)
- Go (`brew install go`)
- Java (`brew install openjdk`)
- C# (`brew install --cask dotnet-sdk`)
- Node.js (`brew install node`)

### Web & search (TTY)
- **w3m** — terminal web browser
- **ddgr** — DuckDuckGo search from terminal
- **tldr** — simplified man pages
- `curl cheat.sh/<command>` — instant command cheatsheets

### API & backend tools
- **xh** — HTTP client (modern httpie alternative)
- **jq** — JSON processing

## Symlinks

| Dotfile | Target |
|---------|--------|
| `tmux/.tmux.conf` | `~/.tmux.conf` |
| `starship/.config/starship.toml` | `~/.config/starship.toml` |
| `nvim/.config/nvim` | `~/.config/nvim` |
| `zshrc/.zshrc` | `~/.zshrc` |
