" Single line comment for any languages
function! SingleLineComment(r0, r1, sign)
    let l:lnum = line(a:r0)
    let l:end = line(a:r1)
    let l:add_sign = 0
    for line in getline(l:lnum, l:end)
        if match(line, '^[\t* *]*'.a:sign, 0) < 0
            let l:add_sign = 1
            break
        endif
    endfor
    for line in getline(l:lnum, l:end)
        if l:add_sign
            call setline(l:lnum, substitute(line, '^', a:sign, 'g'))
        else
            call setline(l:lnum, substitute(line, '^\(\t*\s*\)*'.a:sign, '', 'g'))
        endif
        let l:lnum = l:lnum + 1
    endfor
endfunction

" Examples
augroup CConfig
    autocmd!
    autocmd BufNewFile,BufRead *.c,*.h,*.c.inc set filetype=c
    "  by typing <C-v><C-/>
    autocmd FileType c xnoremap  :<c-u>call SingleLineComment("'<", "'>", '//')<cr>
    autocmd FileType c nnoremap  :call SingleLineComment(".", ".", '//')<cr>
augroup END

augroup VimConfig
    autocmd!
    autocmd BufNewFile,BufRead *.vim,*.vimrc set filetype=vim
    "  by typing <C-v><C-/>
    autocmd FileType vim xnoremap  :<c-u>call SingleLineComment("'<", "'>", '"')<cr>
    autocmd FileType vim nnoremap  :call SingleLineComment(".", ".", '"')<cr>
augroup END