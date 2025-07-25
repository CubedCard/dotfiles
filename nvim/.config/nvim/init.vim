"===============================
" BASIC SETTINGS
"===============================
set nocompatible
syntax on
filetype plugin indent on

let mapleader=" "

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
Plug 'sainnhe/sonokai'
Plug 'morhetz/gruvbox'
Plug 'preservim/nerdtree'
Plug 'junegunn/goyo.vim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lua/plenary.nvim'

" Treesitter & LSP
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'neovim/nvim-lspconfig'

" Fun
Plug 'alec-gibson/nvim-tetris'
Plug 'eandrju/cellular-automaton.nvim'
Plug 'm4xshen/hardtime.nvim'
Plug 'ThePrimeagen/vim-be-good'

" Autocompletion
Plug 'hrsh7th/nvim-cmp'                      " Completion engine
Plug 'hrsh7th/cmp-nvim-lsp'                  " LSP source
Plug 'hrsh7th/cmp-buffer'                    " Buffer source
Plug 'hrsh7th/cmp-path'                      " Path completion
Plug 'hrsh7th/cmp-cmdline'                   " Cmdline completion
Plug 'L3MON4D3/LuaSnip'                      " Snippet engine
Plug 'saadparwaiz1/cmp_luasnip'              " Snippet completion source

call plug#end()

"===============================
" COLORSCHEME
"===============================
set background=dark
let g:gruvbox_italic=1

augroup ColorSchemeOverride
  autocmd!
  autocmd FileType html colorscheme sonokai
  autocmd FileType * colorscheme gruvbox
augroup END

"===============================
" KEYBINDINGS
"===============================

" Insert mode escape
inoremap jj <esc>

" NERDTree toggle
nnoremap <C-p> :NERDTree<CR>

" Goyo toggle
nnoremap <leader>g :Goyo<CR>

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
" LSP CONFIGURATION
"===============================
lua << EOF
local lspconfig = require('lspconfig')

-- Setup language servers
lspconfig.pyright.setup{}
lspconfig.angularls.setup{}
lspconfig.gopls.setup{}
lspconfig.html.setup{}
lspconfig.cssls.setup{}
lspconfig.jsonls.setup{}
lspconfig.omnisharp.setup{
  cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) }
}

-- Key mappings for LSP
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {silent=true})
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, {silent=true})
vim.keymap.set('n', 'gr', vim.lsp.buf.references, {silent=true})
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {silent=true})
vim.keymap.set('n', 'K', vim.lsp.buf.hover, {silent=true})
vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, {silent=true})
vim.keymap.set('n', '<C-n>', vim.diagnostic.goto_prev, {silent=true})
vim.keymap.set('n', '<C-b>', vim.diagnostic.goto_next, {silent=true})
EOF

"===============================
" TREESITTER CONFIG
"===============================
lua << EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = {"c_sharp", "html", "css", "json"},
  highlight = { enable = true }
}
EOF

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

local servers = { 'pyright', 'angularls', 'gopls', 'html', 'cssls', 'jsonls', 'omnisharp' }

for _, server in ipairs(servers) do
  lspconfig[server].setup {
    capabilities = capabilities
  }
end
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

local servers = { 'pyright', 'angularls', 'gopls', 'html', 'cssls', 'jsonls', 'omnisharp' }

for _, server in ipairs(servers) do
  lspconfig[server].setup {
    capabilities = capabilities
  }
end
EOF

"===============================
" HARDTIME CONFIG
"===============================
lua << EOF
require('hardtime').setup()
EOF
