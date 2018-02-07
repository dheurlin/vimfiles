set encoding=utf-8
set backspace=2 " make backspace work like most other apps"
syntax on

" TEST, find out what syntax group we're in
" augroup temporary_test
"       autocmd CursorMoved <buffer>
"           \ echo map(synstack(line('.'), col('.')),
"           \ 'synIDattr(v:val, "name")')
" augroup END

""" Shortcut to edit .vimrc
command! Vrc edit ~/.vimrc

""" map :W to save, to avoid the situation where you try to save but
""" accedently hold shift
command! W w

""""" Setup netrw to look like NERDtree

let g:netrw_banner       = 0
let g:netrw_liststyle    = 3
let g:netrw_browse_split = 4
let g:netrw_altv         = 1
let g:netrw_winsize      = 25


""" NERDtree settings

" Toggle nerdtree using Ctrl+k
map <C-k> <plug>NERDTreeTabsToggle<CR>
" Don't open NERDTree when new tab opens (cos we're using buffers instead of
" tabs now)
let g:nerdtree_tabs_open_on_new_tab = 0
" Only open nerdtree if we opened vim in a directory
let g:nerdtree_tabs_open_on_gui_startup = 2
let g:nerdtree_tabs_open_on_console_startup = 2

" Hide certain file types in NERDtree
let NERDTreeIgnore = ['\.pyc$', '\.class$']

""" Setup CtrlP so that it doesn't open files in NERDtree buffer
function! CtrlPCommand()
    let c = 0
    let wincount = winnr('$')
    " Don't open it here if current buffer is not writable (e.g. NERDTree)
    while !empty(getbufvar(+expand("<abuf>"), "&buftype")) && c < wincount
        exec 'wincmd w'
        let c = c + 1
    endwhile
    exec 'CtrlP'
endfunction

let g:ctrlp_cmd = 'call CtrlPCommand()'

" make it show hidden files
let g:ctrlp_show_hidden = 1


""" Remap the leader key (\) to ö for ease on Swedish keyboard
let mapleader = "ö"

""" Enable mouse
set ttymouse=xterm2
set mouse=a

""" Changecursor in different modes in tmux
let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
let &t_SR = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=2\x7\<Esc>\\"
let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"

""" Use incremental search
set incsearch


""" Highlight trailing whitespace
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=darkred guibg=darkred
au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
au InsertLeave * match ExtraWhitespace /\s\+$/

""" Functions to automatically remove trailing whitespace
"" Credits to vim.wikia.org
function! ShowSpaces(...)
  let @/='\v(\s+$)|( +\ze\t)'
  let oldhlsearch=&hlsearch
  if !a:0
    let &hlsearch=!&hlsearch
  else
    let &hlsearch=a:1
  end
  return oldhlsearch
endfunction

function! TrimSpaces() range
  let oldhlsearch=ShowSpaces(1)
  execute a:firstline.",".a:lastline."substitute ///gec"
  let &hlsearch=oldhlsearch
endfunction

command! -bar -nargs=? ShowSpaces call ShowSpaces(<args>)
command! -bar -nargs=0 -range=% TrimSpaces <line1>,<line2>call TrimSpaces()
nnoremap <leader>w   m`:TrimSpaces<CR>``
vnoremap <leader>w   :TrimSpaces<CR>

""" Setup spell checking
command! SpellEN setlocal spell spelllang=en_us
command! SpellSW setlocal spell spelllang=sv
command! NoSpell setlocal nospell
autocmd ColorScheme * highlight clear SpellBad
autocmd ColorScheme * highlight SpellBad ctermfg=09 guifg=#ff0000
autocmd ColorScheme * highlight clear SpellCap
autocmd ColorScheme * highlight SpellCap ctermfg=10 guifg=#00ff00
autocmd ColorScheme * highlight clear SpellRare
autocmd ColorScheme * highlight SpellRare ctermfg=10 guifg=#00ff00


""" Configure Smooth Scrolling
function! SetSmoothScrollSlow()
    noremap <silent> <c-u> :call smooth_scroll#up   (&scroll   , 4 , 1)<CR>
    noremap <silent> <c-d> :call smooth_scroll#down (&scroll   , 4 , 1)<CR>
    noremap <silent> <c-b> :call smooth_scroll#up   (&scroll*2 , 4 , 3)<CR>
    noremap <silent> <c-f> :call smooth_scroll#down (&scroll*2 , 4 , 3)<CR>
endfunction

function! SetSmoothScrollFast()
    noremap <silent> <c-u> :call smooth_scroll#up   (&scroll   , 0 , 4)<CR>
    noremap <silent> <c-d> :call smooth_scroll#down (&scroll   , 0 , 4)<CR>
    noremap <silent> <c-b> :call smooth_scroll#up   (&scroll*2 , 0 , 6)<CR>
    noremap <silent> <c-f> :call smooth_scroll#down (&scroll*2 , 0 , 6)<CR>
endfunction

""" Setup line numbers

" Toggle between relative and absolute line numbers
" and speed up scrolling when relative, because otherwise it gets laggy
function! RelNumDisable()
    set nornu
    call SetSmoothScrollSlow()
endfunc

function! RelNumEnable()
    set relativenumber
    call SetSmoothScrollFast()
endfunc

function! NumberToggle()
  if(&relativenumber == 1)
    call RelNumDisable()
  else
    call RelNumEnable()
  endif
endfunc

nnoremap <leader>rn :call NumberToggle()<cr>

" Display line numbers
set number
" Show relative numbers by default
call RelNumEnable()

""" Plugins
call plug#begin('~/.vim/plugged')

Plug 'hzchirs/vim-material'
Plug 'scrooloose/nerdtree'
Plug 'vim-syntastic/syntastic'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'rcabralc/monokai-airline.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'kien/ctrlp.vim'
Plug 'lifepillar/vim-solarized8'
Plug 'chriskempson/base16-vim'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'terryma/vim-smooth-scroll'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
Plug 'suy/vim-context-commentstring' "Makes vim commentary change comment type when language changes within file
Plug 'tpope/vim-surround'
Plug 'vim-scripts/applescript.vim'
Plug 'godlygeek/tabular'
Plug 'python-mode/python-mode'
Plug 'Raimondi/delimitMate'
Plug 'plasticboy/vim-markdown'
Plug 'lervag/vimtex'
Plug 'terryma/vim-multiple-cursors'
Plug 'justinmk/vim-sneak'

call plug#end()


""" Set color theme

" disable CSApprox for now, cos it breks italic fonts for some reason
let g:CSApprox_loaded = 1

" For gui and true color terminals (currently just iTerm)
let term_program=$TERM_PROGRAM

if has("gui_running") || (term_program == "iTerm.app" && has("termguicolors"))


" For 256-color terminals
else

endif

let g:my_colo_dark         = 'base16-tomorrow-night'
let g:my_colo_light        = 'solarized8_light'
let g:my_airline_dark      = 'monokai'
let g:my_airline_light     = 'solarized'
let g:airline_solarized_bg = 'dark'

set t_Co=256 " Enable 256-color-mode
let &t_AB="\e[48;5;%dm"
let &t_AF="\e[38;5;%dm"

set t_8f=[38;2;%lu;%lu;%lum  " Needed in tmux
set t_8b=[48;2;%lu;%lu;%lum  " Ditto
set termguicolors " enable true colors


" autocmd Colorscheme * highlight Comment cterm=italic gui=italic
" Set line nr background to background color of text
autocmd Colorscheme * execute 'hi LineNr guibg='.synIDattr(hlID("Normal"), "bg")

exe 'colo '.g:my_colo_dark
let g:airline_theme = g:my_airline_dark

" toggle between dark and light themes
function! ToggleLightDarkTheme()

    " change main colors:
    if (exists('g:my_colo_dark') && exists('g:colors_name'))
        if g:colors_name == g:my_colo_dark
            exe 'colo '.g:my_colo_light
        else
            exe 'colo '.g:my_colo_dark
        endif
    endif

    " change airline theme
    if (exists('g:my_airline_dark') && exists('g:airline_theme'))
        if g:airline_theme == g:my_airline_dark
            exe 'AirlineTheme '.g:my_airline_light
        else
            exe 'AirlineTheme '.g:my_airline_dark
        endif
    endif

endfunction

nnoremap <leader>b :call ToggleLightDarkTheme()<cr>

""" Make iTerm automatically change to the 'Vim' profile when opening vim,
" and change back when exiting
if term_program =="iTerm.app"
   let curr_theme=system("~/.vim/iterm-prof.sh --get-current")

   autocmd VimEnter * :silent ! ~/.vim/iterm-prof.sh --set "Vim"
   autocmd VimLeave * :execute '! ~/.vim/iterm-prof.sh --set "'.curr_theme.'"'
endif


""" Convert tabs to spaces, tab = 4 spaces
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent  "Keep indentation from previous line
filetype plugin indent on

""" Make line wrapping be nice
if has("patch-7.4.354")
    set breakindent
endif

""" Define extensions

augroup filetypedetect
    " associate *.pmd with markdown filetype
    au BufRead,BufNewFile *.pmd setfiletype markdown
    " au BufRead,BufNewFile *.nlogo setfiletype nlogo
    " au BufRead,BufNewFile *.nls setfiletype nlogo
augroup END

""" Comments

" AppleScript should use # as comment style
autocmd FileType applescript :setlocal commentstring=#\ %s

" Matlab uses %
autocmd FileType matlab setlocal commentstring=\%\ %s

" So does literate haskell
autocmd FileType lhaskell setlocal commentstring=\%\ %s

" Markdown comments can be acheived the same way as HTML comments
autocmd FileType markdown setlocal commentstring=<!--%s-->
autocmd FileType markdown :setlocal commentstring=<!--%s-->

" Netlogo comments are ;;

" autocmd FileType 

" Php should use // as comment style, but html in php files should be
" commented like html. To make this happe, we set the default
" comment style in php to the html style, and set the comment
" style of 'phpRegion' to the normal php style
autocmd FileType php :setlocal commentstring=<!--%s-->

if !exists("g:context#commentstring#table")
    let g:context#commentstring#table = {}
endif

let g:context#commentstring#table.php = {
    \ 'phpRegion' : '//  %s',
    \ }

" Setup context sensitive comments for other languages
let g:context#commentstring#table.vim = {
            \ 'vimLuaRegion'     : '--%s',
            \ 'vimPerlRegion'    : '#%s',
            \ 'vimPythonRegion'  : '#%s',
            \}

let g:context#commentstring#table.html = {
            \ 'javaScript'  : '//%s',
            \ 'cssStyle'    : '/*%s*/',
            \}

let g:context#commentstring#table.xhtml = g:context#commentstring#table.html

""" Python mode

" only show documentation when autocompleting
let g:pymode_doc = 0
" remove doc after autocompletion is done
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif


""" Configure Markdown Mode


" Define extension that specifies that the file is a pandoc markdown.
" Only these will be auto-compiled to pdf when we save

source ~/.vim/syntax-specific/markdown.vim

""" Literate haskell
au FileType lhaskell set filetype=tex
au FileType lhaskell SpellEN
autocmd FileType lhaskell setlocal textwidth=80

""" Haskell
au FileType haskell set colorcolumn=80

""" LaTeX
au FileType tex SpellEN
au FileType tex setlocal textwidth=80
au FileType tex setlocal ts=2 sw=2 sts=2 et

""" Folding
" set folds unfolded by default
au BufRead * normal zR

""" Configure delimitMate (auto pairs)
let delimitMate_expand_cr = 1

""" Set airline to use powerfonts (to support cool separators)
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'

" powerline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

" old vim-powerline symbols
" (The ones that aren't commented look better than the PL ones)
" let g:airline_left_sep = '⮀'
" let g:airline_left_alt_sep = '⮁'
" let g:airline_right_sep = '⮂'
" let g:airline_right_alt_sep = '⮃'
" let g:airline_symbols.branch = '⭠'
" let g:airline_symbols.readonly = '⭤'
" let g:airline_symbols.linenr = '⭡'

""" Configure airline to replace the tab-bar with open buffers

" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_tabs = 0

" Show just the filename if it's unique, otherwise add path to make it unique
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#fnamemod = ':t'

" let g:airline#extensions#tabline#tab_nr_type = 1 " tab number
" let g:airline#extensions#tabline#show_tab_nr = 1
" let g:airline#extensions#tabline#buffer_nr_show = 1

" Make it use straight tabs
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

" Make it use VimDevicons
let g:airline_powerline_fonts = 1
" Also make nerdtree use folder icons
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:DevIconsEnableFoldersOpenClose = 1

" after a re-source, fix syntax matching issues (concealing brackets):
if exists('g:loaded_webdevicons')
    call webdevicons#refresh()
endif

" This allows buffers to be hidden if you've modified a buffer.
" This is almost a must if you wish to use buffers in this way.
set hidden

let g:airline#extensions#tabline#buffer_idx_mode = 1
" let g:airline#extensions#tabline#buffer_nr_show = 1
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9

" To open a new empty buffer
nmap <leader>T :enew<cr>
" Move to the next buffer
nmap <leader>l <Plug>AirlineSelectNextTab
" Move to the previous buffer
nmap <leader>h <Plug>AirlineSelectPrevTab
" Close the current buffer and move to the previous one
" This replicates the idea of closing a tab
nmap <leader>bq :bp <BAR> bd #<CR>
" Show all open buffers and their status
nmap <leader>bl :ls<CR>

" Hide highlighted line underline in terminal
hi CursorLine   cterm=NONE ctermbg=darkred ctermfg=white


""" Setup syntastic options for syntax checking
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_java_javac_config_file_enabled = 1

let g:syntastic_mode_map = { 'mode': 'passive' }
