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
Plugin 'evanleck/vim-svelte', {'branch': 'main'}
Plugin 'svg.vim'


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
" avec Konsole
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_SR = "\<Esc>]50;CursorShape=2\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

" avec gnome
if has("autocmd")
  au VimEnter,InsertLeave * silent execute '!echo -ne "\e[1 q"' | redraw!
  au InsertEnter,InsertChange *
    \ if v:insertmode == 'i' |
    \   silent execute '!echo -ne "\e[5 q"' | redraw! |
    \ elseif v:insertmode == 'r' |
    \   silent execute '!echo -ne "\e[3 q"' | redraw! |
    \ endif
  au VimLeave * silent execute '!echo -ne "\e[ q"' | redraw!
endif

" change couleur curseur si mode insert ou mode normal/visuel
if &term =~ "xterm\\|rxvt"
  " use an orange cursor in insert mode
  let &t_SI = "\<Esc>]12;orange\x7"
  " use a red cursor otherwise
  let &t_EI = "\<Esc>]12;red\x7"
  silent !echo -ne "\033]12;red\007"
  " reset cursor when vim exits
  autocmd VimLeave * silent !echo -ne "\033]112\007"
  " use \003]12;gray\007 for gnome-terminal and rxvt up to version 9.21
endif


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
set guifont=Source\ Code\ Pro\ 12



" 'jiangmiao/auto-pairs' ==> set paste pose problème avec ce plugin essentiel
" set paste

set background=dark
colorscheme palenight

" touch f9 ==> liste les fichiers du dossier et sous-dossiers
nnoremap <silent> <F9> :NERDTreeToggle<CR>
" \c + c ==> commente ligne par ligne
" \c + space ==> commente bloc
nnoremap <leader>cc :call NERDComment('x', 'toggle')<CR>

