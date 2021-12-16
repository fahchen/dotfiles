-- autocmds
vim.cmd [[autocmd! BufRead,BufNewFile *.json set filetype=jsonc]]
vim.cmd [[autocmd! BufRead,BufNewFile *.livemd set filetype=markdown]]

-- jump last position
vim.cmd [[ autocmd BufRead * autocmd FileType <buffer> ++once if &ft !~# 'commit\|rebase' && line("'\"") > 1 && line("'\"") <= line("$") | exe 'normal! g`"' | endif ]]

-- Lsp
vim.cmd [[autocmd CursorHoldI,CursorMovedI * lua vim.lsp.diagnostic.show_line_diagnostics({focusable=false})]]
