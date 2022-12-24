vim9script
# Line comment for any languages.
def LineComment(r0: string,
                r1: string,
                sign: string,
                extra_sign: string = ' ',
                align: number = &tabstop)

    var need_sign = v:false
    var indent = 999
    for lnr in range(line(r0), line(r1))
        var line = getline(lnr)
        if len(line) == 0
            continue
        endif
        need_sign = need_sign || match(line, '^[\t* *]*' .. sign, 0) < 0
        indent = min([indent(lnr), indent])
        # indent = ((a, b) => a < b ? a : b)(indent(lnr), indent)
    endfor
    # Round indent down to nearest multiple. Requires that align be a power of 2.
    indent = and(indent, -align)
    # Prepend or remove signs.
    for lnr in range(line(r0), line(r1))
        var line = getline(lnr)
        if len(line) == 0
            continue
        endif
        # Prepend a sign.
        if need_sign
            # Find a good position for sign, even if '\t' exists in a line.
            for i in range(0, len(line))
                var prev = strpart(line, 0, i)
                setline(lnr, prev)
                if indent(lnr) < indent
                    continue
                endif
                var next = strpart(line, i)
                var newline = prev .. sign .. extra_sign .. next
                setline(lnr, newline)
                break
            endfor
        # Remove a sign.
        else
            var sign_match = match(line, sign, 0)
            var prev = strpart(line, 0, sign_match)
            var next = strpart(line, sign_match + len(sign))
            if match(next, extra_sign, 0) == 0
                next = strpart(next, len(extra_sign))
            endif
            var newline = prev .. next
            setline(lnr, newline)
        endif
    endfor
enddef

def SingleLineComment(sign: string)
    LineComment(".", ".", sign)
enddef

def MultiLineComment(sign: string)
    LineComment("'<", "'>", sign)
enddef
defcompile

# Examples
# Typing  by <C-v><C-/>
augroup LineCommentConfig
    autocmd!
    # C
    autocmd BufNewFile,BufRead,BufEnter *.c,*.h,*.c.inc setlocal filetype=c
    autocmd FileType c xnoremap <silent>  :<c-u>call <sid>MultiLineComment('//')<cr>
    autocmd FileType c nnoremap <silent>  :call <sid>SingleLineComment('//')<cr>
    # Vim
    autocmd BufNewFile,BufRead,BufEnter *.vim,*.vimrc setlocal filetype=vim
    autocmd FileType vim xnoremap <silent>  :<c-u>call <sid>MultiLineComment('#')<cr>
    autocmd FileType vim nnoremap <silent>  :call <sid>SingleLineComment('#')<cr>
    # Bash, Make, Python
    autocmd BufNewFile,BufRead,BufEnter *.sh setlocal filetype=sh
    autocmd BufNewFile,BufRead,BufEnter Makefile* setlocal filetype=make
    autocmd BufNewFile,BufRead,BufEnter *.py setlocal filetype=python
    autocmd FileType make,sh,python xnoremap <silent>  :<c-u>call <sid>MultiLineComment('#')<cr>
    autocmd FileType make,sh,python nnoremap <silent>  :call <sid>SingleLineComment('#')<cr>
    # Lua
    autocmd BufNewFile,BufRead,BufEnter *.lua setlocal filetype=lua
    autocmd FileType lua xnoremap <silent>  :<c-u>call <sid>MultiLineComment('--')<cr>
    autocmd FileType lua nnoremap <silent>  :call <sid>SingleLineComment('--')<cr>
augroup END
