" let g:ycm_path_to_python_interpreter = '/usr/local/Cellar/python/2.7.13/Frameworks/Python.framework/Versions/2.7/bin'

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-sensible'
Plug 'altercation/vim-colors-solarized'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
" Plug 'Valloric/YouCompleteMe'
Plug 'kien/ctrlp.vim'
Plug 'tpope/vim-fugitive'
Plug 'scrooloose/nerdtree'

call plug#end()

" Behave like Vim instead of Vi
set nocompatible

syntax on

filetype plugin indent on
set tabstop=4
set shiftwidth=4
set expandtab

" http://ethanschoonover.com/solarized/vim-colors-solarized
syntax enable
set background=dark
" colorscheme solarized

" format with goimports instead of gofmt
let g:go_fmt_command = "goimports"

let g:netrw_liststyle=3

" Ignore files when searching
set wildignore+=*/tmp/*,*.so,*.swp,*.zip
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'

if has('mouse')
  " Enable mouse use in all modes
  set mouse=a
  "if exists('$ITERM_PROFILE')
  "  autocmd VimEnter * set ttymouse=xterm2
  "  autocmd FocusGained * set ttymouse=xterm2
  "  autocmd BufEnter * set ttymouse=xterm2
  "endif
endif

if has('mouse_sgr')
  set ttymouse=sgr
endif

if has("gui_running")
    " running MacVim
else
    " running inside terminal
    set clipboard=unnamed
endif

" Navigate with split windows without ctrl-w prefix
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Open new split panes to right and bottom
set splitbelow
set splitright
