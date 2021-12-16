local functions = {}

functions.copy_file_path = function()
  local file_path = vim.fn['expand']('%:.')
  print(file_path)

  vim.fn['setreg']('*', file_path, 'c')
end

return functions
