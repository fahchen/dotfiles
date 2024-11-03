-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

vim.keymap.del("t", "<C-h>")
vim.keymap.del("t", "<C-j>")
vim.keymap.del("t", "<C-k>")
vim.keymap.del("t", "<C-l>")
vim.keymap.del("n", "<C-_>")
vim.keymap.del("t", "<C-_>")

-- lazygit
vim.keymap.del("n", "<leader>gg")
vim.keymap.del("n", "<leader>gG")
vim.keymap.del("n", "<leader>gb")
vim.keymap.del("n", "<leader>gB")
-- `<leader>gl` is overwrited by vim-gh-line
-- vim.keymap.del("n", "<leader>gl")
vim.keymap.del("n", "<leader>gL")
map("n", "<leader>gz", function()
  LazyVim.lazygit()
end, { desc = "Lazygit (cwd)" })
