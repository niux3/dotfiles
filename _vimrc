set nocompatible      " Nécessaire
filetype off          " Nécessaire

" Ajout de Vundle au runtime path et initialisation
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" On indique à Vundle de s'auto-gérer :)
Plugin 'gmarik/Vundle.vim'  " Nécessaire

Plugin 'editorconfig/editorconfig-vim'
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
Plugin 'preservim/tagbar'
" Plugin 'Valloric/YouCompleteMe'
Plugin 'neoclide/coc.nvim'

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
  let &t_SI = "\<Esc>]12;\3465A4\x7"
  " use a red cursor otherwise
  let &t_EI = "\<Esc>]12;\3465A4\x7"
  silent !echo -ne "\033]12;\3465A4\007"
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
set noshowmode
set mouse=a
set tabstop=4
set expandtab
set noswapfile
set shiftwidth=4
set softtabstop=4
set scrolloff=10
set sidescrolloff=10
set cursorline
set splitbelow
set splitright
set ai
set wrap
set ignorecase
set smartcase
set title
" set hlsearch
set omnifunc=syntaxcomplete#Complete
set encoding=UTF-8
set clipboard="unnamedplus"
set guifont=Source\ Code\ Pro\ 12

set nobackup
set nowritebackup
set updatetime=300
set signcolumn=yes




" 'jiangmiao/auto-pairs' ==> set paste pose problème avec ce plugin essentiel
" set paste

set background=dark
colorscheme palenight

" ctrl p
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.?(git|__pycache__|idea|vsc|vscode|hg|svn|node_modules|venv)$',
  \ 'file': '\v\.(exe|so|dll|pyc)$',
  \ 'link': 'some_bad_symbolic_links',
  \ }

" touch f9 ==> liste les fichiers du dossier et sous-dossiers
nnoremap <silent> <F9> :NERDTreeToggle<CR>

nnoremap <F8> :TagbarToggle<CR>
" \c + c ==> commente ligne par ligne
" \c + space ==> commente bloc
nnoremap <leader>cc :call NERDComment('x', 'toggle')<CR>

" tab
nnoremap tt :tabnew<CR>
nnoremap tn :tabnext<CR>
nnoremap tp :tabprev<CR>
nnoremap tc :tabclose<CR>

" copier/coller
vnoremap <C-c> "+y
map <C-v> "+p

" Start NERDTree. If a file is specified, move the cursor to its window.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * NERDTree | if argc() > 0 || exists("s:std_in") | wincmd p | endif

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

let g:user_emmet_leader_key='<C-E>'

" svelte plug
let g:svelte_indent_script = 0
let g:svelte_indent_style = 0

" COC
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

