set nocompatible      " Nécessaire
filetype off          " Nécessaire

" Ajout de Vundle au runtime path et initialisation
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" On indique à Vundle de s'auto-gérer :)
Plugin 'gmarik/Vundle.vim'  " Nécessaire

Plugin 'itchyny/lightline.vim'
Plugin 'drewtempelmeyer/palenight.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'pangloss/vim-javascript'
Plugin 'kien/ctrlp.vim'
Plugin 'jiangmiao/auto-pairs'
Plugin 'mattn/emmet-vim'
Plugin 'preservim/nerdtree'
Plugin 'davidhalter/jedi-vim'
Plugin 'preservim/nerdcommenter'
Plugin 'vim-syntastic/syntastic'
Plugin 'nvie/vim-flake8'
Plugin 'ackyshake/VimCompletesMe'

Plugin 'glench/vim-jinja2-syntax'


call vundle#end()            " Nécessaire
filetype plugin indent on    " Nécessaire

" theme
let g:lightline = { 'colorscheme': 'palenight' }
let g:airline_theme = "palenight"
let g:airline#extensions#branch#enabled=1
let g:loaded_delimitMate = 1
let g:palenight_terminal_italics=1

" Error symbols
let g:syntastic_error_symbol = "✗"
let syntastic_style_error_symbol = "✗"
let g:syntastic_warning_symbol = "∙∙"
let syntastic_style_warning_symbol = "∙∙"

" change cursor
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_SR = "\<Esc>]50;CursorShape=2\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

" permet d'avoir un thème sympathique
if has('termguicolors')
  set termguicolors
endif


function! SetupCtrlP()
  if exists("g:loaded_ctrlp") && g:loaded_ctrlp
    augroup CtrlPExtension
      autocmd!
      autocmd FocusGained  * CtrlPClearCache
      autocmd BufWritePost * CtrlPClearCache
    augroup END
  endif
endfunction

if has("autocmd")
    autocmd VimEnter * :call SetupCtrlP()
    autocmd! bufwritepost .vimrc source ~/.vimrc
endif

let python_highlight_all=1
let NERDTreeShowHidden=1
set t_Co=256
syntax on
set number
set rnu
set backspace=indent,eol,start
set smartindent
set autoindent
set showcmd
set mouse=a
set tabstop=4
set expandtab
set noswapfile
set shiftwidth=4
set softtabstop=4
set ai
set omnifunc=syntaxcomplete#Complete
set encoding=utf-8
set clipboard=unnamed



" 'jiangmiao/auto-pairs' ==> set paste pose problème avec ce plugin essentiel
" set paste

set background=dark
colorscheme palenight

nnoremap <silent> <F9> :NERDTreeToggle<CR>
nnoremap <leader>cc :call NERDComment('x', 'toggle')<CR>

