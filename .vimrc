set encoding=utf-8
set backspace=2 " make backspace work like most other apps"
syntax on
set ruler

set undofile
set undodir=~/.vim/undodir

""" Shortcut to edit .vimrc
command! Vrc edit ~/.vimrc

""" map :W to save, to avoid the situation where you try to save but
""" accedently hold shift
command! W w

imap <C-L> <DEL>

"" Don't highlight shit after searcg
set nohlsearch

""" Remap the leader key (\) to ö for ease on Swedish keyboard and localleader
"" to ä
let mapleader      = " "
let maplocalleader = "ä"

""" Set the status line

set statusline=
set statusline+=\ %f
set statusline+=%=
set statusline+=%#CursorLineNr#
set statusline+=\ %p%%
set statusline+=\ %l:%c
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]
set statusline+=\ 

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

"""""""" Bindings for fzf

" For c-p, call GitFiles (respecting gitignore) if in git repo, otherwise call
" Files
function! GetGitRoot()
  let root = split(system('git rev-parse --show-toplevel'), '\n')[0]
  return v:shell_error ? '' : root
endfunction

function! MyFiles()
  let root = GetGitRoot()
  if empty(root)
    execute 'Files'
  else
    execute 'GFiles'
  endif
endfunction

nnoremap <C-p> :call MyFiles()<cr>

" Ignore filenames for Rg
command! -bang -nargs=* Rg call
            \ fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case "
            \ .shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)
nnoremap <leader>g :Rg<CR>


""" Enable mouse in visual and normal modes
set mouse=nv

""" Use incremental search
set incsearch

""" Trailing whitespace
source ~/.vim/include/spaces.vim

""" Spell checking
source ~/.vim/include/spellcheck.vim

""" Setup line numbers

" Toggle between relative and absolute line numbers
function! RelNumDisable()
    set nornu
endfunc

function! RelNumEnable()
    set relativenumber
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
Plug 'rcabralc/monokai-airline.vim'
Plug 'lifepillar/vim-solarized8'
Plug 'chriskempson/base16-vim'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
Plug 'suy/vim-context-commentstring' "Makes vim commentary change comment type when language changes within file
Plug 'tpope/vim-surround'
Plug 'justinmk/vim-sneak'
Plug 'ap/vim-buftabline'
Plug 'herringtondarkholme/yats.vim'
Plug 'edwinb/idris2-vim'
Plug 'neovimhaskell/haskell-vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'gdetrez/vim-gf'
"" LSP Stuff
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp' " Autocompletion plugin
Plug 'hrsh7th/cmp-nvim-lsp' " LSP source for nvim-cmp
Plug 'saadparwaiz1/cmp_luasnip' " Snippets source for nvim-cmp
Plug 'L3MON4D3/LuaSnip' " Snippets plugin
call plug#end()

"" LSP settings
" Consult
" https://github.com/kolyamba2105/config-files/tree/master/.config/nvim/lua
" for reasonable settings
lua require('lsp')
source ~/.vim/include/lsp-config.vim

""" Set color theme

let g:my_colo_dark         = 'base16-classic-dark'
let g:my_colo_light        = 'solarized8_light'
let g:my_airline_dark      = 'base16_classic'
let g:my_airline_light     = 'solarized'
let g:airline_solarized_bg = 'dark'

set t_8f=[38;2;%lu;%lu;%lum  " Needed in tmux
set t_8b=[48;2;%lu;%lu;%lum  " Ditto
set termguicolors " enable true colors

if !exists('$TMUX')
    autocmd Colorscheme * highlight Comment cterm=italic gui=italic
endif
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

endfunction

nnoremap <leader>b :call ToggleLightDarkTheme()<cr>

""" Convert tabs to spaces, tab = 4 spaces

function! SetTabs(n)
    exe "setlocal tabstop=".a:n
    exe "setlocal softtabstop=".a:n
    exe "setlocal shiftwidth=".a:n
endfunction

nnoremap <leader>t2 :call SetTabs(2)<cr>
nnoremap <leader>t4 :call SetTabs(4)<cr>

call SetTabs(4)
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
augroup END

""" Comments

autocmd FileType applescript setlocal commentstring=#\ %s
autocmd FileType matlab      setlocal commentstring=\%\ %s
autocmd FileType lhaskell    setlocal commentstring=\%\ %s
autocmd FileType markdown    setlocal commentstring=<!--%s-->
autocmd FileType markdown    setlocal commentstring=<!--%s-->
autocmd FileType fut         setlocal commentstring=--\ %s

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

""" Configure Markdown Mode

source ~/.vim/include/markdown.vim

""" Literate haskell
au FileType lhaskell set filetype=tex
au FileType lhaskell SpellEN
autocmd FileType lhaskell setlocal textwidth=80

""" Haskell
au FileType haskell setlocal colorcolumn=80
au FileType haskell call SetTabs(2)

"" GF
au FileType gf call SetTabs(2)

""" Html
au FileType html       call SetTabs(2)
au FileType htmldjango call SetTabs(2)

""" JS / TS ---------------------------------
au FileType javascript call SetTabs(2)
au FileType typescript call SetTabs(2)
" set filetypes as typescriptreact
autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescriptreact
au FileType typescriptreact call SetTabs(2)

""" Idris

""" LaTeX
au FileType tex SpellEN
au FileType tex setlocal textwidth=80
au FileType tex setlocal ts=2 sw=2 sts=2 et

""" Folding
" set folds unfolded by default
au BufRead * normal zR

""" Configure delimitMate (auto pairs)
let delimitMate_expand_cr = 1

" To open a new empty buffer
nmap <leader>T :enew<cr>
" Move to the next buffer
nmap <leader>l :bn!<CR>
" Move to the previous buffer
nmap <leader>h :bp!<CR>
" Close the current buffer and move to the previous one
" This replicates the idea of closing a tab
nmap <leader>bq :bp <BAR> bd #<CR>
" Show all open buffers and their status
nmap <leader>bl :ls<CR>

"" buftabline options """"""""""""""""""""
let g:buftabline_show       = 1
let g:buftabline_numbers    = 2
let g:buftabline_indicators = 1
let g:buftabline_separators = 1

nmap <leader>1 <Plug>BufTabLine.Go(1)
nmap <leader>2 <Plug>BufTabLine.Go(2)
nmap <leader>3 <Plug>BufTabLine.Go(3)
nmap <leader>4 <Plug>BufTabLine.Go(4)
nmap <leader>5 <Plug>BufTabLine.Go(5)
nmap <leader>6 <Plug>BufTabLine.Go(6)
nmap <leader>7 <Plug>BufTabLine.Go(7)
nmap <leader>8 <Plug>BufTabLine.Go(8)
nmap <leader>9 <Plug>BufTabLine.Go(9)
nmap <leader>0 <Plug>BufTabLine.Go(10)

" Hide highlighted line underline in terminal
hi CursorLine   cterm=NONE ctermbg=darkred ctermfg=white

inoremap <Up> <NOP>
inoremap <Down> <NOP>
inoremap <Left> <NOP>
inoremap <Right> <NOP>

noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>
