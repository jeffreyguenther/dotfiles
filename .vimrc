""""""""""""""""""""""""""""""""""""""""
" Jeffrey Guenther Vimrc configuration
""""""""""""""""""""""""""""""""""""""""
set nocompatible
syntax on
set nowrap
set encoding=utf8
set noswapfile

" Allow copy and pasting between vim and OS
set clipboard+=unnamed,unnamedplus

""" START Vundle Configuration

" Disable file type for vundle
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, require
Plugin 'VundleVim/Vundle.vim'

" tmux integration
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'tpope/vim-obsession'

" Editor
Plugin 'scrooloose/nerdtree'
Plugin 'ryanoasis/vim-devicons'
Plugin 'derekprior/vim-leaders'
Plugin 'derekprior/vim-trimmer'
Plugin 'pbrisbin/vim-mkdir'
Plugin 'tpope/vim-rsi'
Plugin 'vim-scripts/tComment'

" Language Utilities
Plugin 'w0rp/ale'
Plugin 'Townk/vim-autoclose'
Plugin 'tpope/vim-endwise'
Plugin 'andrewradev/splitjoin.vim'
Plugin 'janko-m/vim-test'
Plugin 'sheerun/vim-polyglot'
" Snippets
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'garbas/vim-snipmate'
Plugin 'honza/vim-snippets'

" Git
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'

" Ruby
Plugin 'vim-ruby/vim-ruby'

" Javascript
Plugin 'pangloss/vim-javascript'

" Markdown / Writing
Plugin 'tpope/vim-markdown'
Plugin 'jtratner/vim-flavored-markdown'
Plugin 'LanguageTool'

" HTML
Plugin 'mattn/emmet-vim'
Plugin 'Valloric/MatchTagAlways'
" Theme
Plugin 'trusktr/seti.vim'

call vundle#end()            " required
filetype plugin indent on    " required
"""" END Vundle Configuration

"""""""""""""""""""""""""""""""""""""
" Configuration Section
"""""""""""""""""""""""""""""""""""""

" Set Leader
let mapleader = " "

" Show linenumbers
set number
set ruler

" Turn on syntax highlighting allowing local overrides
syntax enable

" Enable highlighting of the current line
set cursorline
$
" Whitespace
set nowrap                        " don't wrap lines
set tabstop=2                     " a tab is two spaces
set shiftwidth=2                  " an autoindent (with <<) is two spaces
set expandtab                     " use spaces, not tabs
set list                          " Show invisible characters
set backspace=indent,eol,start    " backspace through everything in insert mode

" List chars
set listchars=""                  " Reset the listchars
set listchars=tab:».               " a tab should display as "", trailing whitespace as "."
set listchars+=trail:.            " show trailing spaces as dots
set listchars+=extends:>          " The character to show in the last column when wrap is
" off and the line continues beyond the right of the screen
set listchars+=precedes:<         " The character to show in the last column when wrap is
" off and the line continues beyond the left of the screen

" Searching
set hlsearch    " highlight matches
set incsearch   " incremental searching
set ignorecase  " searches are case insensitive...
set smartcase   " ... unless they contain at least one capital letter

" Disable output and VCS files
set wildignore+=*.o,*.out,*.obj,.git,*.rbc,*.rbo,*.class,.svn,*.gem

" Disable archive files
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz

" Ignore bundler and sass cache
set wildignore+=*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*/.sass-cache/*

" Ignore librarian-chef, vagrant, test-kitchen and Berkshelf cache
set wildignore+=*/tmp/librarian/*,*/.vagrant/*,*/.kitchen/*,*/vendor/cookbooks/*

" Ignore rails temporary asset caches
set wildignore+=*/tmp/cache/assets/*/sprockets/*,*/tmp/cache/assets/*/sass/*

" Disable temp and backup files
set wildignore+=*.swp,*~,._*

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
nnoremap <leader>s :call FzyCommand("rg --files", ":sp")<cr>

" Fuzzy search in current directory
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
nnoremap <leader>rv :call RgFzyGlobSearch(':vs')<cr>

" With support for autocmd
if has("autocmd")
  " Save buffer when it loses focus
  if exists("g:autosave_on_blur")
    au FocusLost * silent! wall
  endif

  " Make sure all mardown files have the correct filetype set and setup wrapping
  au BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn,txt} setf markdown
  if !exists("g:disable_markdown_autostyle")
    au FileType markdown setlocal wrap linebreak textwidth=72 nolist
  endif

  " Remember last location in file, but not for commit messages.
  " see :help last-position-jump
  au BufReadPost * if &filetype !~ '^git\c' && line("'\"") > 0 && line("'\"") <= line("$")
        \| exe "normal! g`\"" | endif
endif

" General Mappings (Normal, Visual, Operator-pending)
" format the entire file
nnoremap <leader>fef :normal! gg=G``<CR>

" upper/lower word
nmap <leader>u mQviwU`Q
nmap <leader>l mQviwu`Q

" upper/lower first char of word
nmap <leader>U mQgewvU`Q
nmap <leader>L mQgewvu`Q

" set text wrapping toggles
nmap <silent> <leader>tw :set invwrap<CR>:set wrap?<CR>

" find merge conflict markers
nmap <silent> <leader>fc <ESC>/\v^[<=>]{7}( .*\|$)<CR>

" Map the arrow keys to be based on display lines, not physical lines
map <Down> gj
map <Up> gk

" Toggle hlsearch with <leader>hs
nmap <leader>hs :set hlsearch! hlsearch?<CR>

" Toggle relative line numbers
nmap <leader>ln :set relativenumber! relativenumber?<CR>

" Adjust viewports to the same size
map <Leader>= <C-w>=

" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Toggle NERDTree
map <C-n> :NERDTreeToggle<CR>

" Manage vimrc
" Edit vimrc
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
" Source vimrc
nnoremap <leader>sv :source $MYVIMRC<cr>

" Writing Settidgs
" This is the path if installed via brew
let g:languagetool_jar  = '/usr/local/Cellar/languagetool/4.2/libexec/languagetool-commandline.jar'

" Use github flavoured markedown by default
augroup markdown
  au!
  au BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown
augroup END

" Vim-Test Mappings
nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>
nmap <silent> <leader>g :TestVisit<CR>

" Theme and Styling
set t_Co=256
set background=dark

colorscheme seti

