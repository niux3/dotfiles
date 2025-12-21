" === VIMRC ===
" Sections:
" 1. Options générales
" 2. Interface graphique
" 3. Autocomplétion
" 4. Auto-fermeture
" 5. Netrw + Recherche
" 6. divers
" 7. Raccourcis


" 1. === Options Générales ===

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
set scrolloff=5
set sidescrolloff=5
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



" 2. === Interface graphique ===

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

" définit les templates de barre directement en variables globales pour qu'elles soient accessibles partout
let g:active_stline = "%#StatusLineSel#%{ReadMode()}%#StatusLine# %f %m %r%=%y %p%% %l:%c "
let g:inactive_stline = "%#StatusLineNC# %f %m %r%=%y %p%% %l:%c "

augroup StatusLineControl
  autocmd!
  " Quand on entre dans un buffer ou une fenêtre, on applique la ligne active
  autocmd VimEnter,WinEnter,BufWinEnter * setlocal statusline=%!g:active_stline
  " Quand on quitte la fenêtre, on applique la ligne inactive
  autocmd WinLeave * setlocal statusline=%!g:inactive_stline
augroup END



" 3. === Autocomplétion ===
" Configuration de base
set complete=.                     " Uniquement les mots du buffer courant
set completeopt=menuone,noinsert,noselect
set pumheight=8
set shortmess+=c
set omnifunc=                      " Vide, on ne veut pas d'omnicomplétion

" Mappings ESSENTIELS
inoremap <C-n> <C-x><C-n>
inoremap <C-p> <C-x><C-p>

" Tab intelligent
inoremap <expr> <Tab> CompleteTab()

function! CompleteTab()
  if pumvisible()
    return "\<C-n>"
  endif
  
  let line = getline('.')
  let col = col('.') - 1
  
  " On récupère le mot en cours de frappe
  let before_cursor = line[0:col-1]
  
  " Vérifier si on est dans un mot (lettres/chiffres/_)
  if before_cursor =~ '\v\w+$' && len(before_cursor) >= 2
    " On a tapé au moins 2 caractères d'un mot
    return "\<C-n>"
  endif
  
  " Sinon, tabulation normale
  return "\<Tab>"
endfunction

" Navigation dans le menu
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <CR> pumvisible() ? "\<C-y>\<CR>" : "\<CR>"
inoremap <expr> <Esc> pumvisible() ? "\<C-e>\<Esc>" : "\<Esc>"



" 4. === Auto-fermeture ===
function! ClosePair(char)
  let line = getline('.')
  let col = col('.')
  
  " Si on tape le caractère fermant et qu'il est déjà là
  if a:char == ')' && col <= len(line) && line[col-1] == ')'
    return "\<Right>"
  elseif a:char == ']' && col <= len(line) && line[col-1] == ']'
    return "\<Right>"
  elseif a:char == '}' && col <= len(line) && line[col-1] == '}'
    return "\<Right>"
  elseif a:char == '"' && col <= len(line) && line[col-1] == '"'
    return "\<Right>"
  elseif a:char == "'" && col <= len(line) && line[col-1] == "'"
    return "\<Right>"
  elseif a:char == '`' && col <= len(line) && line[col-1] == '`'
    return "\<Right>"
  endif
  
  " Caractères ouvrants
  if a:char == '('
    return '()' . "\<Left>"
  elseif a:char == '['
    return '[]' . "\<Left>"
  elseif a:char == '{'
    return '{}' . "\<Left>"
  elseif a:char == '"'
    return '""' . "\<Left>"
  elseif a:char == "'"
    return "''" . "\<Left>"
  elseif a:char == '`'
    return '``' . "\<Left>"
  endif
  
  return a:char
endfunction

" Appliquer les mappings
inoremap <expr> ( ClosePair('(')
inoremap <expr> ) ClosePair(')')
inoremap <expr> [ ClosePair('[')
inoremap <expr> ] ClosePair(']')
inoremap <expr> { ClosePair('{')
inoremap <expr> } ClosePair('}')
inoremap <expr> " ClosePair('"')
inoremap <expr> ' ClosePair("'")
inoremap <expr> ` ClosePair('`')

" Saut de ligne automatique pour {
inoremap {<CR> {<CR>}<Esc>O

" Backspace intelligent
inoremap <expr> <BS> CloseBackspace()

function! CloseBackspace()
  let line = getline('.')
  let col = col('.')
  
  if col > 1
    let before = line[col-2]
    let after = line[col-1]
    
    " Vérifier les paires
    if (before == '(' && after == ')') ||
     \ (before == '[' && after == ']') ||
     \ (before == '{' && after == '}') ||
     \ (before == '"' && after == '"') ||
     \ (before == "'" && after == "'") ||
     \ (before == '`' && after == '`')
      return "\<Del>\<BS>"
    endif
  endif
  
  return "\<BS>"
endfunction



" 5. === Netrw ===

" --- Netrw Configuration ---

let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_winsize = 25
let g:netrw_altv = 1  " Force Netrw à gauche



" 6. === change apparence curseur avec gnome ===

" --- change apparence curseur avec gnome ---
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



" 7. === Raccourcis ===

" Raccourcis tabs
nnoremap nt :tabnew<CR>
nnoremap nq :tabclose<CR>

" Raccourcis Netrw
nnoremap <leader>ve :leftabove Vexplore<CR>
nnoremap <leader>se :aboveright Sexplore<CR>
nnoremap <leader>te :Texplore<CR>
nnoremap <leader>e :Explore<CR>
" Toggle Netrw à gauche
nnoremap <F2> :Lexplore<CR>
