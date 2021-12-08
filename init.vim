syntax on

set belloff=all                         "no bell sounds in vim
set tabstop=4 softtabstop=4             "tab length
set shiftwidth=4                        "shift width
set expandtab                           "something with tab
set guicursor=i:block                   "nice cursor
set smartindent                         "smart indentation
set nohlsearch                          "after search, no highlight
set nowrap                              "not auto wrapping long lines of code
set hidden                              "keeps any buffer in the background
set nu rnu                              "numbered lines set no
set noswapfile                          "this is so that vim doesn't create a swap file
set nobackup
"set undodir=~/.vim/undodir
"set undofile
set showmatch                           "show all matching searches
set incsearch                           "search with /
set wildmenu                            "autocomplete in command line

set scrolloff=8                         "keeps 8 lines to the bottom when scrolling
"set spell                               "adds spell check

set cursorline                          "highlight the line that you're at

set signcolumn=yes                      "sidebar with errors
set colorcolumn=120
highlight ColorColumn ctermbg=0 guibg=lightgrey

call plug#begin('~/.vim/plugged')       "install plugins

Plug 'preservim/nerdtree'
Plug 'ThePrimeagen/vim-be-good'
Plug 'sainnhe/sonokai'
Plug 'morhetz/gruvbox'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

call plug#end()

colorscheme gruvbox                     "set colorscheme to gruvbox
set background=dark                     "set dark background

inoremap jj <esc>
nnoremap <C-p> :NERDTree <CR>

autocmd BufEnter * colorscheme gruvbox
autocmd BufEnter *.html colorscheme sonokai 

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

nnoremap <SPACE> <Nop>
let mapleader=" "

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Using Lua functions
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
