return {
  { "arthurxavierx/vim-caser" },
  -- open file path like: path/to/file.ext:12:3
  { "wsdjeg/vim-fetch" },
  {
    "ruanyl/vim-gh-line",
    keys = {
      {
        "<leader>gl",
        function()
          vim.api.nvim_exec2("GH", {})
          print("GitHub line copied to clipboard")
        end,
        mode = { "n" },
        silent = true,
        desc = "Open GitHub line",
      },
    },
    init = function()
      vim.g.gh_line_blame_map_default = 0
      vim.g.gh_repo_map = "<leader>go"

      vim.g.gh_use_canonical = 1
      vim.g.gh_open_command = "function fn; echo -n $argv | pbcopy; end; fn " -- fish shell
    end,
  },
  { "tpope/vim-fugitive", lazy = true },
}
