""""""""""""""""""""""""""""""""""""""""
" Jeffrey Guenther Vimrc configuration
""""""""""""""""""""""""""""""""""""""""

syntax on
set encoding=utf8
set noswapfile

" Set Leader
let mapleader = " "

" Show linenumbers
set number
set ruler

" Searching
set hlsearch    " highlight matches
set incsearch   " incremental searching
set ignorecase  " searches are case insensitive...
set smartcase   " ... unless they contain at least one capital letter

" Whitespace
set nowrap
set splitright
set backspace=indent,eol,start

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Theme
Plugin 'itchyny/lightline.vim'
Plugin 'kaicataldo/material.vim'

" Base Editor
Plugin 'tpope/vim-endwise'
Plugin 'Townk/vim-autoclose'

" git integration
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-rhubarb'
Plugin 'mhinz/vim-signify'

" File Navigation
Plugin 'tpope/vim-projectionist'
Plugin 'gevann/vim-rg'

" Language Tools
Plugin 'dense-analysis/ale'
Plugin 'janko-m/vim-test'

" Ruby
Plugin 'vim-ruby/vim-ruby'
Plugin 'tpope/vim-rails'

" Javascript
Plugin 'pangloss/vim-javascript'

" Elixir
Plugin 'elixir-editors/vim-elixir'
Plugin 'slashmili/alchemist.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

"""""""""""""""""""""""""""""""""""""
" Keymaps  Section
"""""""""""""""""""""""""""""""""""""

" Fuzzy file lookup
function! FzyCommand(choice_command, vim_command)
  try
    let output = system(a:choice_command . " | fzy ")
  catch /Vim:Interrupt/
    " Swallow errors from ^C, allow redraw! below
  endtry
  redraw!
  if v:shell_error == 0 && !empty(output)
    exec a:vim_command . ' ' . output
  endif
endfunction

nnoremap <C-p> :call FzyCommand("rg --files", ":e")<cr>
nnoremap <leader>e :call FzyCommand("rg --files", ":e")<cr>
nnoremap <leader>v :call FzyCommand("rg --files", ":vs")<cr>

" Manage vimrc
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Vim-Test Mappings
nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>
nmap <silent> <leader>g :TestVisit<CR>

" Save
nnoremap <leader>s :w<cr>
nnoremap <leader>w :w<cr>

" Open netrw
nnoremap <C-n> :Lexplore<cr>

"""""""""""""""""""""""""""""""""""""
" Configuration Section
"""""""""""""""""""""""""""""""""""""

let g:signify_vcs_list = [ 'git' ]

let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25

" Theme and Styling
set t_Co=256

if (has('termguicolors'))
  set termguicolors
endif

let g:lightline = { 'colorscheme': 'material' }
let g:material_theme_style = 'darker'
colorscheme material
set laststatus=2
set noshowmode
