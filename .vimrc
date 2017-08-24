
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

""" Remap the leader key (\) to ö for ease on Swedish keyboard
let mapleader = "ö"

""" Disable all mouse functionality (because that's cheating)
set mouse=


""" Configure Smooth Scrolling
function! SetSmoothScrollSlow()
    noremap <silent> <c-u> :call smooth_scroll#up(&scroll, 4, 1)<CR>
    noremap <silent> <c-d> :call smooth_scroll#down(&scroll, 4, 1)<CR>
    noremap <silent> <c-b> :call smooth_scroll#up(&scroll*2, 4, 3)<CR>
    noremap <silent> <c-f> :call smooth_scroll#down(&scroll*2, 4, 3)<CR>
endfunction

function! SetSmoothScrollFast()
    noremap <silent> <c-u> :call smooth_scroll#up(&scroll, 0, 5)<CR>
    noremap <silent> <c-d> :call smooth_scroll#down(&scroll, 0, 5)<CR>
    noremap <silent> <c-b> :call smooth_scroll#up(&scroll*2, 0, 7)<CR>
    noremap <silent> <c-f> :call smooth_scroll#down(&scroll*2, 0, 7)<CR>
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

""" Specify a directory for Plug plugins
call plug#begin('~/.vim/plugged')

Plug 'hzchirs/vim-material'
Plug 'scrooloose/nerdtree'
Plug 'vim-syntastic/syntastic'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'rcabralc/monokai-airline.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'jiangmiao/auto-pairs'
Plug 'kien/ctrlp.vim'
" Plug 'altercation/vim-colors-solarized'
Plug 'lifepillar/vim-solarized8'
Plug 'chriskempson/base16-vim'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'godlygeek/csapprox'
Plug 'terryma/vim-smooth-scroll'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'vim-scripts/applescript.vim'
Plug 'godlygeek/tabular'
Plug 'python-mode/python-mode'

call plug#end()


""" Set color theme
" disable CSApprox for now, cos it breks italic fonts for some reason
let g:CSApprox_loaded = 1
" For gui and true color terminals (currently just iTerm)
let term_program=$TERM_PROGRAM
if has("gui_running") || (term_program == "iTerm.app" && has("termguicolors"))
    set termguicolors " enable true colors
    
    colo base16-default-dark
    let g:airline_theme = 'base16_default'

    " use italic comments
    highlight Comment cterm=italic gui=italic
    " set line numbers bg to bg color
    let bgc=synIDattr(hlID("Normal"), "bg")
    execute 'hi LineNr guibg='.bgc
        
    " Toggle between light jnd dark theme using leader B
    nnoremap  <leader>B :<c-u>exe "colors" (g:colors_name =~# "dark"
    \ ? substitute(g:colors_name, 'dark', 'light', '')
    \ : substitute(g:colors_name, 'light', 'dark', '')
    \ )<cr>

" For 256-color terminals
else
    set t_Co=256 " Enable 256-color-mode
    let &t_AB="\e[48;5;%dm"
    let &t_AF="\e[38;5;%dm"
    
    let g:airline_theme = 'bubblegum'
    colorscheme monokai
endif    

""" Make iTerm automatically change to the 'Vim' profile when opening vim,
" and change back when exiting
if term_program =="iTerm.app"
   let curr_theme=system("~/.vim/iterm-prof.sh --get-current") 

   autocmd VimEnter * :silent ! ~/.vim/iterm-prof.sh --set "Vim"
   autocmd VimLeave * :execute '! ~/.vim/iterm-prof.sh --set "'.curr_theme.'"'
   autocmd VimLeave * :! echo "Hello motherfucker"
endif    


""" Convert tabs to spaces, tab = 4 spaces
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent  "Keep indentation from previous line
filetype plugin indent on
" set smartindent "Automatically inserts indentation in some cases
" set cindent     "Like smartindent, but stricter and more customisable
" " dont remove indentation when pressing #  
" inoremap # X#

""" Comments
" AppleScript should use # as comment style
autocmd FileType applescript :setlocal commentstring=#\ %s

""" Folding
" set folds unfolded by default
au BufRead * normal zR

""" Python mode
" only show documentation when autocompleting
let g:pymode_doc = 0
" remove doc after autocompletion is done
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

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

" Show just the filename if it's unique, otherwise add path to make it unique
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#fnamemod = ':t'

" Set the separators to use 1337 h4xx0rz arrows
" let g:airline#extensions#tabline#left_sep = g:airline_left_sep
" let g:airline#extensions#tabline#right_sep = g:airline_right_sep
" let g:airline#extensions#tabline#left_alt_sep = g:airline_left_alt_sep
" let g:airline#extensions#tabline#right_alt_sep = g:airline_right_alt_sep

" Actually, let's use straight tabs instead
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

" To open a new empty buffer
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

""" Auto-pairs config
let g:AutoPairsShortcutFastWrap='' "auto-pairs breaks å for some reason. This fixes it

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


