-- https://github.com/neovim/neovim/issues/5683#issuecomment-886417209
vim.cmd [[ lang en_US.UTF-8 ]]

vim.o.clipboard = 'unnamedplus'

vim.wo.number = true
vim.wo.relativenumber = true

vim.o.mouse = 'a'
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.shiftround = true
vim.o.autoindent = true
vim.o.wrap = false
vim.o.cursorline = true
vim.o.scrolloff = 5
vim.o.encoding = 'utf-8'
vim.o.scrolloff = 2
vim.o.linebreak = true

vim.o.foldlevel = 999
vim.o.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"

-- spell check
vim.o.spell = true
vim.o.spelllang = 'en'
vim.opt.complete:append('kspell')
vim.o.spellcapcheck = ''

-- show non-printable characters
vim.o.list = true
vim.o.listchars = 'tab:▸ ,extends:❯,precedes:❮,nbsp:±,trail:·'

vim.opt.undofile = true

vim.o.hlsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

-- Set colorscheme (order is important here)
vim.o.termguicolors = true
vim.g.onedark_terminal_italics = 2
vim.cmd [[colorscheme nord]]

-- Leader key
vim.api.nvim_set_keymap('', ',', '<Nop>', { noremap = true, silent = true })
vim.g.mapleader = ','
vim.g.maplocalleader = ','

-- Plugins

vim.g.nvim_tree_special_files = {
  ["Cargo.toml"] = true,
  Makefile = true,
  ["README.md"] = true,
  ["readme.md"] = true,
  ["mix.exs"] = true,
  ["packages.json"] = true,
  ["Dockerfile"] = true,
}
