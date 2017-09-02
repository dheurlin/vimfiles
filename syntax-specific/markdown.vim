" Activate english spell checker
autocmd FileType markdown SpellEN

" Add syntax highlighting for LaTeX
let g:vim_markdown_math = 1

" also make it work for \begin{...} ... \end{...} blocks
autocmd FileType markdown syn region mkdMath start="\\begin{.*}" end="\\end{.*}" contains=@tex keepend

" Command for compiling current file using pandoc, without 
" printing stuff to the terminal
function! CompMD()
    silent exec "! (~/.vim/md-make.sh '%:p'&) > /dev/null"
    redraw!
endfunction

autocmd FileType markdown command! -buffer CompMD call CompMD()

" Make it automatically compile when we save the buffer
autocmd BufWritePost *.pmd CompMD

" Command for opening the pdf of the current file in zathura
function! OpenPDF()
    silent exec "! (~/.vim/open-note-setup.sh '%:p'.pdf &) > /dev/null"
    redraw!
endfunction

autocmd FileType markdown command! -buffer OpenPDF call OpenPDF()

" Key binding for inserting link
autocmd FileType markdown nnoremap <buffer> <c-i>l i[]()<esc>F[a

" Command for inserting image from link
autocmd FileType markdown command! -buffer -nargs=1 -complete=file ImgFromLink normal "='![]('.<q-args>.')'<c-m>PF[

" autocmd FileType markdown command! -buffer -nargs=1 -complete=file 
    " \ FigFromLink normal "='\begin{figure}[h]\\t\includegraphics[]{'.<q-args>.'}\t\caption{}\t\end{figure}'<c-m>Pk

" Rotates an image. This requires that the image be included using
" inline LaTeX, so if it is not already, we convert it
" function! RotImg(deg)
"     " If we dont already haev the inline LaTeX
"     let line=getline('.')
"     if line =~ '!\[.*\]\(.*\)'
"        s /!\[(.*)\]\((.*)\)/hej \1 och \2/ 
"     else
"         echo "fuck you"
"     endif
" endfunction


" " ![hej, hag heter kuk](lslsls)
    
