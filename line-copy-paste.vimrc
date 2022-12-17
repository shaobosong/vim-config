" line copy and paste among different vim sessions
vnoremap <silent> gy :write! /tmp/vim.clipboard<CR>
noremap <silent> gy :. write! /tmp/vim.clipboard<CR>
noremap <silent> gp :read /tmp/vim.clipboard<CR>
noremap <silent> gP :-1 read /tmp/vim.clipboard<CR>