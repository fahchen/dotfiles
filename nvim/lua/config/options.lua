-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.mapleader = ","

vim.opt.spell = true -- Enable spell check
vim.opt.spellfile = { vim.fn.expand("~/.local/share/nvim/site/spell/words.add") }
vim.opt.spelllang = { "en", "cjk" }

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

-- Prepend mise shims to PATH
vim.env.PATH = vim.env.HOME .. "/.local/share/mise/shims:" .. vim.env.PATH

vim.filetype.add({
  extension = {
    mdx = "markdown.mdx",
  },
})
