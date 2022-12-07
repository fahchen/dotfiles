local functions = {}

functions.copy_file_path = function()
  local file_path = vim.fn['expand']('%:.')
  print(file_path)

  vim.fn['setreg']('*', file_path, 'c')
end

functions.set_window_width_to_max_line_width = function()
  -- 计算行号范围
  local start_line = vim.api.nvim_eval('line("w0")')
  local end_line = vim.api.nvim_eval('line("w$")')

  -- 获取当前 buffer 的可视的所有行
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line - 1, false)

  -- 初始化最长长度
  local max_width = vim.api.nvim_win_get_width(0)

  local number_width = 6

  -- 遍历每一行
  for _, line in ipairs(lines) do
    -- 计算当前行的字符长度 plus number_width
    local line_length = string.len(line) + number_width

    -- 更新最长长度
    max_width = math.max(max_width, line_length)
  end


  -- 设置当前 window 的宽度
  vim.api.nvim_win_set_width(0, max_width)
end

return functions
