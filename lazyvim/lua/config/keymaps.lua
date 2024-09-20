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
  -- 计算行号范围
  local start_line = vim.api.nvim_eval('line("w0")')
  local end_line = vim.api.nvim_eval('line("w$")')

  -- 获取当前 buffer 的可视的所有行
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line - 1, false)

  -- 初始化最长长度
  local max_width = vim.api.nvim_win_get_width(0)

  local number_width = 10

  -- 遍历每一行
  for _, line in ipairs(lines) do
    -- 计算当前行的字符长度 plus number_width
    local line_length = string.len(line) + number_width

    -- 更新最长长度
    max_width = math.max(max_width, line_length)
  end

  -- 设置当前 window 的宽度
  vim.api.nvim_win_set_width(0, max_width)
end)

-- better up/down
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- buffers
vim.keymap.set("n", "<A-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
vim.keymap.set("n", "<A-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })

-- Clear search with <esc>
vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- save file
vim.keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- formatting
vim.keymap.set({ "n", "v" }, "<leader>cf", function()
  Util.format({ force = true })
end, { desc = "Format" })

-- quit
vim.keymap.set("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

-- sort lines
vim.api.nvim_set_keymap('v', '<C-o>', ':sort<CR>', { noremap = true, silent = true })
