set nocompatible              " be iMproved, required
filetype off                  " requiredi

" Leader
let mapleader = " "
" Allows copy and pasting between vim and system
set clipboard+=unnamed,unnamedplus

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
Plugin 'ctrlpvim/ctrlp.vim'

Plugin 'scrooloose/nerdtree'
Plugin 'vim-scripts/tComment'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'

" Language-specific packages
Plugin 'vim-ruby/vim-ruby'
Plugin 'tpope/vim-rails'
" Plugin 'terryma/vim-multiple-cursors'
Plugin 'pbrisbin/vim-mkdir'

Plugin 'christoomey/vim-run-interactive'
" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Theme settings
syntax on
set background=dark
colorscheme onedark

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag --literal --files-with-matches --nocolor --hidden -g "" %s'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0

  if !exists(":Ag")
    command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
    nnoremap \ :Ag<SPACE>
  endif
endif

" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Autocomplete with dictionary words when spell check is on
set complete+=kspell

" Move the search windo to the top of the screen
" let g:ctrlp_match_window_bottom = 0
" let g:ctrlp_match_window_reversed =0

set rtp+=/usr/local/lib/python3.7/site-packages/powerline/bindings/vim/
set laststatus=2
set t_Co=256

" Adjust the cursor
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

" optional reset cursor on start:
augroup myCmds
au!
autocmd VimEnter * silent !echo -ne "\e[2 q"
augroup END

let g:gitgutter_terminal_reports_focus=0
map <C-n> :NERDTreeToggle<CR>

set rtp+=/usr/local/opt/fzf
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

nnoremap <C-p> :call FzyCommand("ag . --silent -l -g ''", ":vs")<cr>
nnoremap <leader>e :call FzyCommand("ag . --silent -l -g ''", ":e")<cr>
nnoremap <leader>v :call FzyCommand("ag . --silent -l -g ''", ":vs")<cr>
nnoremap <leader>s :call FzyCommand("ag . --silent -l -g ''", ":sp")<cr>

map <Meta-w> :w<cr>

