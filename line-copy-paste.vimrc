" line copy and paste among different vim sessions
xnoremap <silent> gy :write! /tmp/vim.clipboard<CR>
nnoremap <silent> gy :. write! /tmp/vim.clipboard<CR>
xnoremap <silent> gp d:-1 read /tmp/vim.clipboard<CR>
xnoremap <silent> gP d:-1 read /tmp/vim.clipboard<CR>
nnoremap <silent> gp :read /tmp/vim.clipboard<CR>
nnoremap <silent> gP :-1 read /tmp/vim.clipboard<CR>