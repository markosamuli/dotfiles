" EditorConfig support, bundled with Vim since 9.0.1799. `silent!` keeps
" older Vims, which do not ship the package, from erroring.
silent! packadd! editorconfig

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

syntax enable
set background=dark

let g:netrw_liststyle=3

" Ignore files when searching
set wildignore+=*/tmp/*,*.so,*.swp,*.zip

if has('mouse')
  " Enable mouse use in all modes
  set mouse=a
endif

if has('mouse_sgr')
  set ttymouse=sgr
endif

" Use the system clipboard for yank and put
set clipboard=unnamed

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
