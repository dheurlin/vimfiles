" Activate english spell checker
SpellEN

" Add syntax highlighting for LaTeX
let g:vim_markdown_math = 1
" also make it work for \begin{...} ... \end{...} blocks
 
syn region mkdMath start="\\begin{.*}" end="\\end{.*}" contains=@tex keepend

" Command for compiling current file using pandoc, without 
" printing stuff to the terminal
function! CompMD()
    silent exec "! (~/.vim/md-make.sh '%:p'&) > /dev/null"
    redraw!
endfunction

command! -buffer CompMD call CompMD()

" Make it automatically compile when we save the buffer
autocmd BufWritePost *.pmd CompMD

" Command for opening the pdf of the current file in zathura
function! OpenPDF()
    " silent exec "! (zathura '%:p'.pdf &) > /dev/null"
    silent exec "! (~/.vim/open-note-setup.sh '%:p'.pdf &) > /dev/null"
    redraw!
endfunction

command! -buffer OpenPDF call OpenPDF()

" Key binding for inserting link
nnoremap <buffer> <c-i>l i[]()<esc>F[a

" Command for inserting image from link
command!  -buffer -nargs=1 -complete=file
     \ ImgFromLink normal "='![]('.<q-args>.')'<c-m>P


    
