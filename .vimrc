set nocompatible              " be iMproved, required
filetype off                  " required
set noswapfile

" Leader
let mapleader = " "
" Allows copy and pasting between vim and system
set clipboard+=unnamed,unnamedplus
set spell
set spelllang=en
" Editor Appearance
set number
set list listchars=tab:»·,trail:·,nbsp:·,eol:¬
set expandtab
set tabstop=2
set shiftwidth=2
set backspace=indent,eol,start

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, require
Plugin 'VundleVim/Vundle.vim'

" Theme
Plugin 'joshdick/onedark.vim'

Plugin 'scrooloose/nerdtree'
Plugin 'vim-scripts/tComment'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
Plugin 'ntpeters/vim-better-whitespace'

" Language-specific packages
Plugin 'vim-ruby/vim-ruby'
Plugin 'tpope/vim-rails'
Plugin 'pbrisbin/vim-mkdir'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'junegunn/goyo.vim'
Plugin 'tpope/vim-obsession'
" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif
" Theme settings
syntax on
set background=dark
colorscheme onedark
highlight LineNr ctermfg=grey

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

nnoremap <C-p> :call FzyCommand("rg --files", ":vs")<cr>
nnoremap <leader>e :call FzyCommand("rg --files", ":e")<cr>
nnoremap <leader>v :call FzyCommand("rg --files", ":vs")<cr>

function! RgFzyGlobSearch(vim_command)
  try
    let rg_command = "rg .
          \ --line-number
          \ --column
          \ --no-heading
          \ --fixed-strings
          \ --ignore-case
          \ --hidden
          \ --follow
          \ --glob '!{.git,node_modules}'"
    " Right now, this function requires rg to print path:line#:column# so awk can replace the output.
    let filename_and_location = system(rg_command . " | fzy | awk -F ':' '{print $1 \"\|\" $2 \"\|\" $3}' ")
  catch /Vim:Interrupt/
    " Swallow errors from ^C, allow redraw! below
  endtry
  redraw!
  if v:shell_error == 0 && !empty(filename_and_location)
    let output = split(filename_and_location, '|')
    execute a:vim_command . ' ' . output[0]
    call cursor(output[1], output[2])
  endif
endfunction

nnoremap <leader>re :call RgFzyGlobSearch(':e')<cr>
nnoremap <leader>rv :call RgFzyGlobSearch(':vs')<cr>noremap <leader>s :call FzyCommand("rg --files", ":sp")<cr>

let g:strip_whitespace_on_save=1

function! RSpecCommand(lines)
  let cmd = "! bundle exec rspec " . expand('%') .":" . a:lines
  echom cmd
  exec cmd
endfunction

command! -nargs=1 RSpec :call RSpecCommand(<args>)
nnoremap <leader>t :! bundle exec rspec %<cr>
nnoremap <leader>ft :execute "RSpec " . line('.')<cr>
