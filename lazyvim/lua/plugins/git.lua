return {
  { "wsdjeg/vim-fetch" },
  {
    "ruanyl/vim-gh-line",
    init = function()
      vim.g.gh_repo_map = '<leader>go'
      vim.g.gh_line_map = '<leader>gl'
      vim.g.gh_line_blame_map = '<leader>gb'
      vim.g.gh_use_canonical = 1
      vim.g.gh_open_command = 'function fn; echo -n $argv | pbcopy; end; fn ' -- fish shell
    end
  },
}
