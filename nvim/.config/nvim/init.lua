-- Neovim on Windows: full IDE-ish, CLI-first setup (C#/.NET + Python, no Angular)
-- Drop this file at: %LOCALAPPDATA%/nvim/init.lua

-----------------------------------------------------
-- Core settings (ported from your init.vim)
-----------------------------------------------------
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local o, wo, bo = vim.o, vim.wo, vim.bo

-- UI
o.termguicolors = true
wo.number = true
wo.relativenumber = true
wo.cursorline = true
o.signcolumn = 'yes'
o.colorcolumn = '120'

-- Cursor style
-- Insert: block (like your guicursor=i:block); keep defaults otherwise
o.guicursor = 'n-v-c:block,i:block,r-cr:hor20,o:hor50'

-- Text layout
o.textwidth = 120

-- Tabs & indentation
o.tabstop = 4
o.shiftwidth = 4
o.softtabstop = 4
o.expandtab = true
o.smartindent = true

-- Scrolling
o.scrolloff = 8
o.sidescrolloff = 8

-- Wrapping
wo.wrap = false

-- Files & backups (Windows-safe paths)
o.undofile = true
o.swapfile = false
-- Put backups/undos in standard state dir
local state = vim.fn.stdpath('state')
o.backup = true
vim.fn.mkdir(state .. '/backup', 'p')
o.backupdir = state .. '/backup//'
vim.fn.mkdir(state .. '/swap', 'p')
o.directory = state .. '/swap//'
o.modeline = false

-- Search
o.hlsearch = false
o.ignorecase = true
o.smartcase = true
o.incsearch = true

-- Command line completion
o.wildmenu = true

-- Disable automatic comments on new lines
vim.api.nvim_create_autocmd('FileType', {
    pattern = '*',
    callback = function()
        vim.opt.formatoptions:remove({ 'c', 'r', 'o' })
    end,
})

-- Backspace behavior
o.backspace = 'indent,eol,start'

-- System clipboard (Windows)
o.clipboard = 'unnamed,unnamedplus'

-- Faster UI
o.updatetime = 200

-----------------------------------------------------
-- Bootstrap lazy.nvim
-----------------------------------------------------
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({ 'git', 'clone', '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazypath })
end
vim.opt.rtp:prepend(lazypath)

-----------------------------------------------------
-- Plugins
-----------------------------------------------------
require('lazy').setup({
    -- Theme
    { 'ellisonleao/gruvbox.nvim', priority = 1000, config = function()
        require('gruvbox').setup({
            italic = { strings = true, comments = true, operators = false, folds = true },
            terminal_colors = true,
            contrast = 'medium',
        }, { rocks = { enabled = false } })
        vim.cmd.colorscheme('gruvbox')
    end },
    -- Quality of life
    { 'nvim-lua/plenary.nvim' },
    { 'nvim-telescope/telescope.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
    { 'nvim-tree/nvim-web-devicons' },
    { 'nvim-neo-tree/neo-tree.nvim', branch = 'v3.x', dependencies = { 'nvim-lua/plenary.nvim', 'nvim-tree/nvim-web-devicons', 'MunifTanjim/nui.nvim' } },
    { 'akinsho/toggleterm.nvim', version = '*', opts = { open_mapping = [[<C-`>]], direction = 'float' } },
    { 'nvim-lualine/lualine.nvim' },
    { 'folke/which-key.nvim', opts = {} },
    { 'folke/trouble.nvim', opts = {} },

    -- Git
    { 'lewis6991/gitsigns.nvim', opts = {} },
    { 'akinsho/git-conflict.nvim', version = '*', config = true },

    -- Treesitter
    { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate',
        opts = {
            ensure_installed = {
                'c_sharp', 'html', 'css', 'json', 'markdown', 'markdown_inline', 'lua', 'vim',
                'python', 'go', 'javascript', 'typescript'
            },
            highlight = { enable = true },
            indent = { enable = true },
        },
        config = function(_, opts) require('nvim-treesitter.configs').setup(opts) end,
    },

    -- LSP + tools manager
    { 'williamboman/mason.nvim', config = true },
    { 'williamboman/mason-lspconfig.nvim' },
    { 'neovim/nvim-lspconfig', version = '<3.0.0' },
    -- Completion & snippets
    { 'hrsh7th/nvim-cmp' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-path' },
    { 'hrsh7th/cmp-cmdline' },
    { 'L3MON4D3/LuaSnip', dependencies = { 'rafamadriz/friendly-snippets' } },
    { 'saadparwaiz1/cmp_luasnip' },

    -- Copilot (Lua version plays nicer with cmp)
    { 'zbirenbaum/copilot.lua', cmd = 'Copilot', opts = {} },
    { 'zbirenbaum/copilot-cmp', dependencies = { 'zbirenbaum/copilot.lua' } },

    -- Formatting/diagnostics bridge
    { 'stevearc/conform.nvim' },

    -- Debugging
    { 'mfussenegger/nvim-dap' },
    { 'rcarriga/nvim-dap-ui', dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' } },

    -- Tasks/Test runners (CLI-first)
    { 'stevearc/overseer.nvim', opts = {} },
    { 'nvim-neotest/neotest' },
    { 'Issafalcon/neotest-dotnet' },
    { 'nvim-neotest/neotest-python' },

    -- Fun (kept from your vimrc)
    { 'eandrju/cellular-automaton.nvim', cmd = { 'CellularAutomaton' } },
    { 'alec-gibson/nvim-tetris', cmd = { 'Tetris' } },
    { 'ThePrimeagen/vim-be-good', cmd = { 'VimBeGood' } },

    -- Startup time
    { 'dstein64/vim-startuptime', cmd = { 'StartupTime' } },
})

-----------------------------------------------------
-- Colorscheme
-----------------------------------------------------

-----------------------------------------------------
-- Keymaps
-----------------------------------------------------
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Insert mode escape
map('i', 'jj', '<Esc>', opts)

-- System clipboard helpers
map('n', '<C-v>', '"+p', opts)
map('v', '<leader>y', '"*y', opts)
map('v', '<leader>p', '"*p', opts)

-- Telescope
map('n', '<leader>ff', require('telescope.builtin').find_files, opts)
map('n', '<leader>fg', require('telescope.builtin').live_grep, opts)
map('n', '<leader>fb', require('telescope.builtin').buffers, opts)
map('n', '<leader>fh', require('telescope.builtin').help_tags, opts)

-- Neo-tree (replaces NERDTree)
map('n', '<C-p>', ':Neotree toggle reveal<CR>', { silent = true })

-- Cellular Automaton
map('n', '<leader>fml', ':CellularAutomaton make_it_rain<CR>', { silent = true })
map('n', '<leader>gol', ':CellularAutomaton game_of_life<CR>', { silent = true })

-- ToggleTerm
map('n', '<leader>tt', ':ToggleTerm<CR>', { silent = true })

-- Trouble (diagnostics list)
map('n', '<leader>xx', function() require('trouble').toggle() end, opts)

-- Dotnet CLI shortcuts via Overseer tasks
vim.api.nvim_create_user_command('DotnetBuild', function()
    require('overseer').run_template({ name = 'dotnet build' })
end, {})
vim.api.nvim_create_user_command('DotnetRun', function()
    require('overseer').run_template({ name = 'dotnet run' })
end, {})
vim.api.nvim_create_user_command('DotnetTest', function()
    require('overseer').run_template({ name = 'dotnet test' })
end, {})
map('n', '<leader>db', ':DotnetBuild<CR>', { silent = true })
map('n', '<leader>dr', ':DotnetRun<CR>', { silent = true })
map('n', '<leader>dt', ':DotnetTest<CR>', { silent = true })

-- Python helpers via Overseer
vim.api.nvim_create_user_command('PyRun', function()
    require('overseer').run_template({ name = 'python run current file' })
end, {})
vim.api.nvim_create_user_command('PyTest', function()
    require('overseer').run_template({ name = 'pytest' })
end, {})
map('n', '<leader>pr', ':PyRun<CR>', { silent = true })
map('n', '<leader>pt', ':PyTest<CR>', { silent = true })

-- Lualine
require('lualine').setup({ options = { theme = 'gruvbox' } })

-----------------------------------------------------
-- Completion setup (nvim-cmp + LuaSnip + Copilot)
-----------------------------------------------------
local cmp = require('cmp')
local luasnip = require('luasnip')
require('luasnip.loaders.from_vscode').lazy_load()

require('copilot').setup({ suggestion = { enabled = false }, panel = { enabled = false } })
require('copilot_cmp').setup()

cmp.setup({
    snippet = {
        expand = function(args) luasnip.lsp_expand(args.body) end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
            else fallback() end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then luasnip.jump(-1)
            else fallback() end
        end, { 'i', 's' }),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'copilot' },
    }, {
            { name = 'buffer' },
            { name = 'path' },
        })
})

-- Cmdline completion
cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = { { name = 'buffer' } }
})
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline' } })
})

-----------------------------------------------------
-- Mason + LSP (Nvim 0.11+ native API)
-----------------------------------------------------
local mason = require('mason')
local mason_lsp = require('mason-lspconfig')

mason.setup{}
mason_lsp.setup{
    ensure_installed = {
        'pyright', 'ruff', 'gopls', 'html', 'cssls', 'jsonls', 'marksman', 'omnisharp'
    },
}

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local function on_attach(_, bufnr)
    local mapb = function(mode, lhs, rhs)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true })
    end
    mapb('n', 'gd', vim.lsp.buf.definition)
    mapb('n', 'gD', vim.lsp.buf.declaration)
    mapb('n', 'gr', vim.lsp.buf.references)
    mapb('n', 'gi', vim.lsp.buf.implementation)
    mapb('n', 'K', vim.lsp.buf.hover)
    mapb('n', '<C-k>', vim.lsp.buf.signature_help)
    mapb('n', '<C-n>', vim.diagnostic.goto_prev)
    mapb('n', '<C-b>', vim.diagnostic.goto_next)
    mapb('n', '<leader>rn', vim.lsp.buf.rename)
    mapb('n', '<leader>ca', vim.lsp.buf.code_action)
end

-- Configure servers using the new API
local servers = {
    pyright = {},
    ruff = {},
    gopls = {},
    html = {},
    cssls = {},
    jsonls = {},
    marksman = {},
    omnisharp = {
        cmd = { 'omnisharp', '--languageserver', '--hostPID', tostring(vim.fn.getpid()) },
        enable_roslyn_analyzers = true,
        organize_imports_on_format = true,
    },
}

for name, opts in pairs(servers) do
    opts.capabilities = capabilities
    opts.on_attach = on_attach
    vim.lsp.config(name, opts)
end

-- Enable all at once (they'll lazy-attach by filetype)
vim.lsp.enable(vim.tbl_keys(servers))

-----------------------------------------------------
-- Formatting
-----------------------------------------------------
require('conform').setup({
    notify_on_error = false,
    format_on_save = function(bufnr)
        local disable_ft = { 'lua' }
        if vim.tbl_contains(disable_ft, vim.bo[bufnr].filetype) then return end
        return { timeout_ms = 1500, lsp_fallback = true }
    end,
    formatters_by_ft = {
        lua = { 'stylua' },
        json = { 'jq' },
        javascript = { 'prettierd', 'prettier' },
        typescript = { 'prettierd', 'prettier' },
        html = { 'prettierd', 'prettier' },
        css = { 'prettierd', 'prettier' },
        markdown = { 'prettierd', 'prettier' },
        cs = { 'csharpier' },
        go = { 'gofmt' },
        python = { 'ruff_format' },
    },
})

-----------------------------------------------------
-- DAP (debugging)
-----------------------------------------------------
local dap = require('dap')
local dapui = require('dapui')

-- C# (requires netcoredbg; set NETCOREDBG_PATH env var or adjust path here)
local netcoredbg = vim.env.NETCOREDBG_PATH or 'netcoredbg'
dap.adapters.coreclr = { type = 'executable', command = netcoredbg, args = { '--interpreter=vscode' }, }
dap.configurations.cs = {
    {
        type = 'coreclr',
        name = 'Launch',
        request = 'launch',
        program = function()
            return vim.fn.input('Path to dll: ', vim.fn.getcwd() .. '/bin/Debug/', 'file')
        end,
    },
}

dapui.setup()

dap.adapters.python = {
    type = 'executable',
    command = 'python',
    args = { '-m', 'debugpy.adapter' },
}

dap.configurations.python = {
    {
        type = 'python',
        request = 'launch',
        name = 'Launch file',
        program = '${file}',
        console = 'integratedTerminal',
        justMyCode = false,
        pythonPath = function()
            return 'python'
        end,
    },
}

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'dap-repl',
    callback = function() vim.wo.wrap = true end,
})

dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open() end

dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close() end

dap.listeners.before.event_exited['dapui_config'] = function() dapui.close() end

-----------------------------------------------------
-- Overseer templates for dotnet & python
-----------------------------------------------------
local overseer = require('overseer')
local templates = {
    {
        name = 'dotnet build',
        builder = function()
            return { cmd = { 'dotnet', 'build' }, components = { 'default' } }
        end,
    },
    {
        name = 'dotnet run',
        builder = function()
            return { cmd = { 'dotnet', 'run' }, components = { 'default' } }
        end,
    },
    {
        name = 'dotnet test',
        builder = function()
            return { cmd = { 'dotnet', 'test' }, components = { 'default' } }
        end,
    },
    {
        name = 'python run current file',
        builder = function()
            return {
                cmd = { 'python', vim.api.nvim_buf_get_name(0) },
                components = { 'default' },
            }
        end,
    },
    {
        name = 'pytest',
        builder = function()
            return { cmd = { 'pytest', '-q' }, components = { 'default' } }
        end,
    },
}
for _, t in ipairs(templates) do overseer.register_template(t) end

-----------------------------------------------------
-- Neotest (dotnet + python)
-----------------------------------------------------
local neotest = require('neotest')
neotest.setup({
    adapters = {
        require('neotest-dotnet')({ discovery_root = 'solution' }),
        require('neotest-python')({ dap = { justMyCode = false } }),
    }
})

-- Simple test keymaps
map('n', '<leader>tr', function() neotest.run.run() end, opts)
map('n', '<leader>tf', function() neotest.run.run(vim.fn.expand('%')) end, opts)
map('n', '<leader>ts', function() neotest.summary.toggle() end, opts)

-----------------------------------------------------
-- Final polish
-----------------------------------------------------
require('which-key').add({
    { '<leader>f', group = 'Find' },
    { '<leader>t', group = 'Test/Terminal' },
    { '<leader>d', group = 'Dotnet' },
    { '<leader>p', group = 'Python' },
    { '<leader>x', group = 'Diagnostics' },
})
