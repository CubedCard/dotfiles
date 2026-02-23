-- 1. Basic Settings
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- 2. Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- 3. Load Plugins
require("lazy").setup({
    { "ellisonleao/gruvbox.nvim", priority = 1000 },
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
    { "neovim/nvim-lspconfig" },
})

-- 4. Apply Theme
vim.cmd([[colorscheme gruvbox]])

-- 5. Treesitter Setup (Safely wrapped)
local status, ts = pcall(require, "nvim-treesitter.configs")
if status then
    ts.setup({
        ensure_installed = { "lua", "vim", "vimdoc", "go", "python" },
        highlight = { enable = true },
    })
end

-- 6. Keybindings
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>f', builtin.find_files, {})
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})

-- Sidebar Menu (Ctrl-p) using the built-in Lex (Netrw)
-- This is faster and requires zero plugins
vim.keymap.set('n', '<C-p>', ':Lex 30<CR>', { silent = true })

-- 7. LSP Auto-attach
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = ev.buf })
    end,
})
