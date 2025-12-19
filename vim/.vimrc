" --- Options Générales ---
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
set scrolloff=10
set sidescrolloff=10
set cursorline
set splitbelow
set splitright
set wrap
set ignorecase
set smartcase
set title
set hlsearch
set encoding=UTF-8
set fileencodings=UTF-8,latin1
set clipboard=unnamedplus
set noshowmode

" --- Rendu graphique ---
set termguicolors
set background=dark
syntax on

" palette (inspirée de Tokyonight)
let s:bg_dark      = "#222436"
let s:bg_highlight = "#3b4261"
let s:fg_gray      = "#799eed"
let s:orange        = "#ff966c"
let s:white        = "#ffffff"

" Fonction robuste (Elle tue le souligné sur GUI et Terminal)
function! s:hi(group, bg, fg, attr)
    let l:cmd = "highlight " . a:group
    if a:bg   != "" | let l:cmd .= " guibg=" . a:bg | endif
    if a:fg   != "" | let l:cmd .= " guifg=" . a:fg | endif
    " On force NONE si rien n'est passé pour éviter les héritages de soulignement
    let l:a = (a:attr == "") ? "NONE" : a:attr
    let l:cmd .= " gui=" . l:a . " cterm=" . l:a
    execute l:cmd
endfunction

" Fond principal et texte (si tu veux vraiment le look Tokyonight)
call s:hi("Normal", s:bg_dark, s:white, "NONE")

" LIGNE COURANTE (C'est ici qu'on tue le souligné)
call s:hi("CursorLine", s:bg_highlight, "", "NONE")
call s:hi("LineNr", "NONE",s:bg_highlight, "NONE")
call s:hi("CursorLineNr", "NONE", s:orange, "bold")

" Splits et Barres
call s:hi("VertSplit", "NONE", s:bg_highlight, "NONE")
call s:hi("StatusLine",    s:bg_highlight, s:white, "NONE")
call s:hi("StatusLineSel", s:white, s:bg_highlight, "bold")
call s:hi("StatusLineNC",  s:bg_highlight, s:fg_gray, "italic")

" Onglets
call s:hi("TabLineFill", s:bg_dark, "NONE", "NONE")
call s:hi("TabLine", s:bg_dark, s:fg_gray, "NONE")
call s:hi("TabLineSel", s:bg_highlight, s:white, "bold")

" Supprimer les soulignés résiduels sur les recherches ou parenthèses
call s:hi("Visual", s:bg_highlight,      "NONE",    "NONE")
call s:hi("MatchParen", s:bg_highlight, s:orange, "NONE")
call s:hi("Search", s:bg_dark, s:white, "NONE")

" --- Caractères de remplissage ---
let &fillchars = "vert:│,stl: ,stlnc: "


" --- Performance et Affichage ---
set nobackup
set nowritebackup
set updatetime=300
set signcolumn=auto
set path+=**
set wildmenu

" --- status line ---
function! ReadMode()
  let l:m = mode()
  if l:m ==# 'n'      | return ' NORMAL '  | endif
  if l:m ==# 'i'      | return ' INSERT '  | endif
  if l:m ==# 'v'      | return ' VISUAL '  | endif
  if l:m ==# 'V'      | return ' V-LINE '  | endif
  if l:m ==# "\<C-V>" | return ' V-BLOCK ' | endif
  if l:m ==# 'R'      | return ' REPLACE ' | endif
  return l:m
endfunction

set laststatus=2

" On définit les templates de barre directement en variables globales pour qu'elles soient accessibles partout
let g:active_stline = "%#StatusLineSel#%{ReadMode()}%#StatusLine# %f %m %r%=%y %p%% %l:%c "
let g:inactive_stline = "%#StatusLineNC# %f %m %r%=%y %p%% %l:%c "

augroup StatusLineControl
  autocmd!
  " Quand on entre dans un buffer ou une fenêtre, on applique la ligne active
  autocmd VimEnter,WinEnter,BufWinEnter * setlocal statusline=%!g:active_stline
  " Quand on quitte la fenêtre, on applique la ligne inactive
  autocmd WinLeave * setlocal statusline=%!g:inactive_stline
augroup END

" --- change apparence cursoeur avec gnome---

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

" --- Raccourcis Tabulations ---
nnoremap nt :tabnew<CR>
nnoremap nq :tabclose<CR>
