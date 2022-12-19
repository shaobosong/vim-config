" Line comment for any languages
function! LineComment(r0, r1, sign, extra_sign, align)
    let l:add_sign = 0
    let l:indent = 999
    for l:lnr in range(line(a:r0), line(a:r1))
        let l:line = getline(l:lnr)
        if match(l:line, '^$', 0) == 0
            continue
        endif
        if match(l:line, '^[\t* *]*' . a:sign, 0) < 0
            let l:add_sign = 1
        endif
        let l:indent =  min([indent(l:lnr), l:indent])
    endfor
    " Alignment on a power-of-two boundary.
    " *align* is assigned as *tabstop* in here.
    let l:indent = and(l:indent, -a:align)
    for l:lnr in range(line(a:r0), line(a:r1))
        let l:line = getline(l:lnr)
        if match(l:line, '^$', 0) == 0
            continue
        endif
        " Add sign
        if l:add_sign
            " Calculate a good indent for *sign*, even if '\t' exists in a line
            for l:i in range(0, len(l:line))
                let l:templine = strpart(l:line, 0, l:i)
                call setline(l:lnr, l:templine)
                if indent(l:lnr) < l:indent
                    continue
                endif
                let l:lprev = strpart(l:line, 0, l:i)
                let l:lnext = strpart(l:line, l:i)
                let l:newline = l:lprev . a:sign . a:extra_sign . l:lnext
                call setline(l:lnr, l:newline)
                break
            endfor
        " Remove sign
        else
            let l:sign_match = match(l:line, a:sign, 0)
            let l:lprev = strpart(l:line, 0, l:sign_match)
            let l:lnext = strpart(l:line, l:sign_match + len(a:sign))
            if match(l:lnext, a:extra_sign, 0) == 0
                let l:lnext = strpart(l:lnext, len(a:extra_sign))
            endif
            let l:newline = l:lprev . l:lnext
            call setline(l:lnr, l:newline)
        endif
    endfor
endfunction

function! SingleLineComment(sign)
    call LineComment(".", ".", a:sign, ' ', &tabstop)
endfunction

function! MultiLineComment(sign)
    call LineComment("'<", "'>", a:sign, ' ', &tabstop)
endfunction

" Examples
augroup CConfig
    autocmd!
    autocmd BufNewFile,BufRead,BufEnter *.c,*.h,*.c.inc setlocal filetype=c
    "  by typing <C-v><C-/>
    autocmd FileType c xnoremap  :<c-u>call MultiLineComment('//')<cr>
    autocmd FileType c nnoremap  :call SingleLineComment('//')<cr>
augroup END

augroup VimConfig
    autocmd!
    autocmd BufNewFile,BufRead,BufEnter *.vim,*.vimrc setlocal filetype=vim
    autocmd FileType vim xnoremap  :<c-u>call MultiLineComment('"')<cr>
    autocmd FileType vim nnoremap  :call SingleLineComment('"')<cr>
augroup END

augroup BashConfig
    autocmd!
    autocmd BufNewFile,BufRead,BufEnter *.sh setlocal filetype=sh
    autocmd FileType sh xnoremap  :<c-u>call MultiLineComment('#')<cr>
    autocmd FileType sh nnoremap  :call SingleLineComment('#')<cr>
augroup END