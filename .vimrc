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

" Indent with four spaces where no .editorconfig applies. EditorConfig
" overrides these for files it covers, which includes everything under
" $HOME through the ~/.editorconfig this repository installs.
set expandtab
set shiftwidth=4
set softtabstop=-1

syntax enable
set background=dark

" Show directories as a tree in netrw, Vim's built-in file browser
" (`vim .`, `:Explore`). 0 is the default one-file-per-line list.
let g:netrw_liststyle=3

" Ignore files when searching
set wildignore+=*/tmp/*,*.so,*.swp,*.zip

" Use the mouse in all modes: click to move the cursor, drag to select in
" visual mode, scroll the buffer with the wheel. Vim then owns mouse events,
" so the terminal's own selection needs a modifier (Shift-drag in Ghostty,
" Option-drag in Terminal.app and iTerm2).
if has('mouse')
  set mouse=a
endif

" Decode terminal mouse reports in the SGR format, which works in every
" column; the older xterm format stops past column 223. Vim only detects SGR
" for $TERM names starting with xterm, and Ghostty uses xterm-ghostty.
if has('mouse_sgr')
  set ttymouse=sgr
endif

" Use the system clipboard for yank and put
set clipboard=unnamed

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
