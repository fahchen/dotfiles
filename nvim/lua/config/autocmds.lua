-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
vim.keymap.set("n", "<m-g>", function()
  local file_path = vim.fn["expand"]("%:.")
  local line_number = vim.fn.line(".")

  print(file_path .. ":" .. line_number)

  vim.fn.setreg("*", file_path .. ":" .. line_number, "c")
end)

vim.keymap.set("n", "<c-g>", function()
  local file_path = vim.fn["expand"]("%:.")

  print(file_path)

  vim.fn.setreg("*", file_path, "c")
end)

vim.keymap.set("n", "<c-w>z", function()
  -- get line range
  local start_line = vim.api.nvim_eval('line("w0")')
  local end_line = vim.api.nvim_eval('line("w$")')

  -- get visual lines
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line - 1, false)

  local max_width = vim.api.nvim_win_get_width(0)

  local number_width = 10

  for _, line in ipairs(lines) do
    local line_length = string.len(line) + number_width

    max_width = math.max(max_width, line_length)
  end

  vim.api.nvim_win_set_width(0, max_width)
end)

-- sort lines
vim.api.nvim_set_keymap("v", "<C-o>", ":sort<CR>", { noremap = true, silent = true })
