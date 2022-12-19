syntax on

"leader key
let mapleader = " "

"you know what these do
set guicursor=i:block
set belloff=all
set nu
set relativenumber

"backup settings for vim
set backupdir=/tmp 
set directory=~/.vim/tmp
set backup

"tabs
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set smartindent

"scroll and sides logic 
set sidescrolloff=8
set scrolloff=8
set cursorline
set signcolumn=yes
set textwidth=120
set colorcolumn=120
highlight ColorColumn ctermbg=0 guibg=lightgrey

"no continuous commenting
set formatoptions-=cro

"files
set undofile
set noswapfile

"search
set showmatch
set ignorecase
set smartcase
set nohlsearch
set incsearch

"autocomplete in command line
set wildmenu

"wrapping logic
set nowrap

"remap for Goyo
nnoremap <leader>g :Goyo<CR>

"yank the line in the clipboard
vnoremap <leader>y "*y
vnoremap <leader>p "*p

call plug#begin('~/.vim/plugged')

Plug 'junegunn/goyo.vim'
Plug 'preservim/nerdtree'
Plug 'ThePrimeagen/vim-be-good'
Plug 'sainnhe/sonokai'
Plug 'morhetz/gruvbox'
Plug 'lervag/vimtex'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

"colorscheme for html should be different
autocmd BufEnter * colorscheme gruvbox
autocmd BufEnter *.html colorscheme sonokai 

"colorscheme logic
colorscheme gruvbox
set background=dark
let g:gruvbox_italic=1

"preferred remaps 
inoremap jj <esc>
nnoremap <C-p> :NERDTree <CR>

"do not run everything
set nomodeline

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

"LSP config
nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <C-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <C-n> <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> <C-b> <cmd>lua vim.lsp.diagnostic.goto_next()<CR>

" npm i -g pyright
lua require('lspconfig').pyright.setup{}
" npm i -g type
lua require('lspconfig').tsserver.setup{}
" npm install -g @angular/language-server
lua require('lspconfig').angularls.setup{}
" brew install gopls
lua require('lspconfig').gopls.setup{}
" npm i -g vscode-langservers-extracted
lua require('lspconfig').html.setup{}
lua require('lspconfig').cssls.setup{}
lua require('lspconfig').jsonls.setup{}

"lua require('lspconfig').jdtls.setup{}

"COC settings
set backspace=indent,eol,start

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

let g:coc_global_extensions = [
            \ 'coc-snippets',
            \ 'coc-pairs',
            \ 'coc-json',
            \ 'coc-java'
            \ ]

let g:copilot_node_command = "~/.nvm/versions/node/v16.18.0/bin/node"
