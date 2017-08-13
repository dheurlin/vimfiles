filetype plugin indent on
syntax on

""""" Setup netrw to look like NERDtree

let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25


""" NERDtree settings

" Toggle nerdtree using Ctrl+k
map <C-k> <plug>NERDTreeTabsToggle<CR>
" Don't open NERDTree when new tab opens (cos we're using buffers instead of
" tabs now)
let g:nerdtree_tabs_open_on_new_tab = 0
" Only open nerdtree if we opened vim in a directory
let g:nerdtree_tabs_open_on_gui_startup = 2
let g:nerdtree_tabs_open_on_console_startup = 2

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

""" Remap the leader key (\) to ö for ease on Swedish keyboard
let mapleader = "ö"

""" NERDComment settings
" insert space after comment delimiter
let g:NERDSpaceDelims = 1


""" Disable all mouse functionality (because that's cheating)
set mouse=
""" Display line numbers
set number
" Make them gray
" highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE


""" Convert tabs to spaces, tab = 4 spaces
"""set tabstop=4
set shiftwidth=4
set expandtab
set autoindent      "Keep indentation from previous line
set smartindent     "Automatically inserts indentation in some cases
set cindent         "Like smartindent, but stricter and more customisable


""" Initialize pathogen, which allows packages to be placed directly inside ~/.vim/bundle/appname/
execute pathogen#infect()

""" Specify a directory for Plug plugins
call plug#begin('~/.vim/plugged')

Plug 'hzchirs/vim-material'
Plug 'scrooloose/nerdcommenter'
Plug 'vim-airline/vim-airline'

call plug#end()


""" Set color theme

" For gui and true color terminals (currently just iTerm)
let term_program=$TERM_PROGRAM
if has("gui_running") || term_program == "iTerm.app"
    set termguicolors " enable true colors

    colorscheme vim-material
    let g:airline_theme = 'material'

" For 256-color terminals
else
    set t_Co=256 " Enable 256-color-mode
    set background=dark
    
    
    let g:airline_theme = 'monokai'
    colorscheme monokai
endif    

" Set airline to use powerfonts (to support cool separators)
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
let g:airline_left_sep = '⮀'
let g:airline_left_alt_sep = '⮁'
let g:airline_right_sep = '⮂'
let g:airline_right_alt_sep = '⮃'
" let g:airline_symbols.branch = '⭠'
" let g:airline_symbols.readonly = '⭤'
" let g:airline_symbols.linenr = '⭡'
    
""" Configure airline to replace the tab-bar with open buffers

" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_tabs = 0
" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'
" Set the separators to use 1337 h4xx0rz arrows
let g:airline#extensions#tabline#left_sep = g:airline_left_sep
let g:airline#extensions#tabline#right_sep = g:airline_right_sep
let g:airline#extensions#tabline#left_alt_sep = g:airline_left_alt_sep
let g:airline#extensions#tabline#right_alt_sep = g:airline_right_alt_sep


" This allows buffers to be hidden if you've modified a buffer.
" This is almost a must if you wish to use buffers in this way.
set hidden

" To open a new empty buffer
" This replaces :tabnew which I used to bind to this mapping
nmap <leader>T :enew<cr>

" Move to the next buffer
nmap <leader>l :bnext<CR>

" Move to the previous buffer
nmap <leader>h :bprevious<CR>

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
