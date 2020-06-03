command! SpellEN setlocal spell spelllang=en_us
command! SpellSW setlocal spell spelllang=sv
command! NoSpell setlocal nospell
autocmd ColorScheme * highlight clear SpellBad
autocmd ColorScheme * highlight SpellBad ctermfg=09 guifg=#ff0000
autocmd ColorScheme * highlight clear SpellCap
autocmd ColorScheme * highlight SpellCap ctermfg=10 guifg=#00ff00
autocmd ColorScheme * highlight clear SpellRare
autocmd ColorScheme * highlight SpellRare ctermfg=10 guifg=#00ff00
