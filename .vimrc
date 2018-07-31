set nocompatible              " be iMproved, required
filetype off                  " requiredi

" Leader
let mapleader = " "
" Allows copy and pasting between vim and system
set clipboard=unnamed,unnamedplus

" Editor Appearance
set number
set list listchars=tab:»·,trail:·,nbsp:·,eol:¬
set expandtab
set tabstop=2
set shiftwidth=2

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, require
Plugin 'VundleVim/Vundle.vim'

" Theme
Plugin 'joshdick/onedark.vim'


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Theme settings
syntax on
set background=dark
colorscheme onedark

" Autocomplete with dictionary words when spell check is on
set complete+=kspell
