call plug#begin()

" https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'

Plug 'tpope/vim-sensible'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'kien/ctrlp.vim'
Plug 'tpope/vim-fugitive'
Plug 'scrooloose/nerdtree'

" fzf installed with Homebrew
Plug '/opt/homebrew/opt/fzf'
" Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Colors
Plug 'dracula/vim', {'as': 'dracula'}

" EditorConfig
Plug 'editorconfig/editorconfig-vim'


call plug#end()

" Behave like Vim instead of Vi
set nocompatible
" Fix backspace
set backspace=indent,eol,start

syntax on

filetype plugin indent on
set autoindent
set smartindent
set smarttab
set softtabstop=4
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
            
" Show row and column ruler information
set ruler	
set colorcolumn=80
autocmd FileType gitcommit setlocal tw=72 
autocmd FileType gitcommit set colorcolumn=72
autocmd FileType go set colorcolumn=80
highlight ColorColumn ctermbg=240 guibg=lightgrey
