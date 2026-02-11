"===============================
" BASIC SETTINGS
"===============================
set nocompatible
syntax on
filetype plugin indent on

let mapleader = " "

" UI
set guicursor=i:block
set belloff=all
set number
set relativenumber
set cursorline
set signcolumn=yes
set textwidth=120
set colorcolumn=120
highlight ColorColumn ctermbg=0 guibg=lightgrey

" Tabs & Indentation
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set smartindent

" Scrolling
set scrolloff=8
set sidescrolloff=8

" Wrapping
set nowrap

" File handling
set undofile
set noswapfile
set backup
set backupdir=/tmp
set directory=~/.vim/tmp
set nomodeline

" Search
set showmatch
set ignorecase
set smartcase
set nohlsearch
set incsearch

" Autocompletion (command line)
set wildmenu

" Disable automatic comments
set formatoptions-=cro

" Backspace
set backspace=indent,eol,start

"===============================
" PLUGINS
"===============================
call plug#begin('~/.vim/plugged')

" UI & Visual
Plug 'morhetz/gruvbox'
Plug 'preservim/nerdtree'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'akinsho/git-conflict.nvim'

" Treesitter & LSP
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'neovim/nvim-lspconfig'

" Fun
Plug 'eandrju/cellular-automaton.nvim', { 'on': 'CellularAutomaton' }
Plug 'alec-gibson/nvim-tetris', { 'on': 'Tetris' }
Plug 'ThePrimeagen/vim-be-good', { 'on': 'VimBeGood' }

" Autocompletion
Plug 'hrsh7th/nvim-cmp'                      " Completion engine
Plug 'hrsh7th/cmp-nvim-lsp'                  " LSP source
Plug 'hrsh7th/cmp-buffer'                    " Buffer source
Plug 'hrsh7th/cmp-path'                      " Path completion
Plug 'hrsh7th/cmp-cmdline'                   " Cmdline completion
Plug 'L3MON4D3/LuaSnip'                      " Snippet engine
Plug 'saadparwaiz1/cmp_luasnip'              " Snippet completion source

"Copilot
Plug 'github/copilot.vim'

"Time tracking
Plug 'dstein64/vim-startuptime'

call plug#end()

"===============================
" COLORSCHEME
"===============================
set background=dark
let g:gruvbox_italic = 1
colorscheme gruvbox

"===============================
" KEYBINDINGS
"===============================

" NERDTree toggle
nnoremap <C-p> :NERDTree<CR>

" Paste system clipboard
nnoremap <C-v> "+p
vnoremap <leader>y "*y
vnoremap <leader>p "*p

" Telescope
nnoremap <leader>ff <cmd>Telescope find_files<CR>
nnoremap <leader>fg <cmd>Telescope live_grep<CR>
nnoremap <leader>fb <cmd>Telescope buffers<CR>
nnoremap <leader>fh <cmd>Telescope help_tags<CR>

" Cellular Automaton
nnoremap <leader>fml <cmd>CellularAutomaton make_it_rain<CR>
nnoremap <leader>gol <cmd>CellularAutomaton game_of_life<CR>

" Dotnet CLI shortcuts
command! DotnetBuild :!dotnet build
command! DotnetRun :!dotnet run
command! DotnetTest :!dotnet test
nnoremap <leader>db :DotnetBuild<CR>
nnoremap <leader>dr :DotnetRun<CR>
nnoremap <leader>dt :DotnetTest<CR>

"===============================
" LSP: lazy, on first FileType
"===============================
lua << EOF
local lspconfig=require('lspconfig')
local util=require('lspconfig.util')
local capabilities=require('cmp_nvim_lsp').default_capabilities()

-- Edit this table to change behavior.
local servers={
  {
    name='pyright',
    ft={'python'},
    root_dir=util.root_pattern('pyproject.toml','setup.py','setup.cfg','requirements.txt','.git'),
    opts={}
  },
  {
    name='gopls',
    ft={'go','gomod','gowork','gotmpl'},
    root_dir=util.root_pattern('go.work','go.mod','.git'),
    opts={}
  },
  {
    name='html',
    ft={'html'},
    root_dir=util.root_pattern('package.json','.git'),
    opts={}
  },
  {
    name='cssls',
    ft={'css','scss','less'},
    root_dir=util.root_pattern('package.json','.git'),
    opts={}
  },
  {
    name='jsonls',
    ft={'json','jsonc'},
    root_dir=util.root_pattern('package.json','.git'),
    opts={}
  },
  {
    name='marksman',
    ft={'markdown','markdown.mdx'},
    root_dir=util.root_pattern('.git'),
    opts={}
  },
  -- Angular: only in real Angular/Nx repos
  {
    name='angularls',
    ft={'typescript','typescriptreact','html'},
    root_dir=util.root_pattern('angular.json','workspace.json','nx.json','.git'),
    opts={}
  },
  -- C#: adjust cmd if needed
  {
    name='omnisharp',
    ft={'cs','csx','cake'},
    root_dir=util.root_pattern('*.sln','.git'),
    opts={
      cmd={'omnisharp','--languageserver','--hostPID',tostring(vim.fn.getpid())}
    }
  }
}

-- Set keymaps once (not per-buffer redefined)
local function lsp_keymaps()
  local map=vim.keymap.set
  local o={silent=true}
  map('n','gd',vim.lsp.buf.definition,o)
  map('n','gD',vim.lsp.buf.declaration,o)
  map('n','gr',vim.lsp.buf.references,o)
  map('n','gi',vim.lsp.buf.implementation,o)
  map('n','K',vim.lsp.buf.hover,o)
  map('n','<C-k>',vim.lsp.buf.signature_help,o)
  map('n','<C-n>',vim.diagnostic.goto_prev,o)
  map('n','<C-b>',vim.diagnostic.goto_next,o)
end
lsp_keymaps()

-- For each server, register a FileType autocmd that:
-- 1) sets up the server the first time we see its ft
-- 2) attaches to the current buffer immediately
for _,s in ipairs(servers) do
  vim.api.nvim_create_autocmd('FileType',{
    pattern=s.ft,
    callback=function(ev)
      if not s._setup_done then
        local cfg=vim.tbl_deep_extend(
          'force',
          {capabilities=capabilities},
          s.opts or {}
        )
        if s.root_dir then cfg.root_dir=s.root_dir end
        lspconfig[s.name].setup(cfg)
        s._setup_done=true
      end
      -- Ensure the server tries to attach to the current buffer now
      if lspconfig[s.name].manager then
        lspconfig[s.name].manager.try_add(ev.buf)
      end
    end
  })
end
EOF

"===============================
" TREESITTER CONFIG
"===============================
lua << EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = {"c_sharp", "html", "css", "json", "markdown", "markdown_inline"},
  highlight = { enable = true }
}
EOF

"===============================
" AUTOCOMPLETION CONFIG 
"===============================
lua << EOF
-- Setup nvim-cmp
local cmp = require'cmp'
local luasnip = require'luasnip'

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, {'i', 's'}),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, {'i', 's'}),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' }
  }, {
    { name = 'buffer' },
    { name = 'path' }
  })
})

-- `/` cmdline completion
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- `:` cmdline completion
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Attach LSP capabilities to nvim-cmp
local capabilities = require('cmp_nvim_lsp').default_capabilities()

local lspconfig = require('lspconfig')

local servers = { 'pyright', 'angularls', 'gopls', 'html', 'cssls', 'jsonls', 'omnisharp', 'marksman' }

for _, server in ipairs(servers) do
  lspconfig[server].setup {
    capabilities = capabilities
  }
end
EOF
