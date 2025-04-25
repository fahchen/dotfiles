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
          local mode = vim.fn.mode()
          print(mode)
          if mode == "v" or mode == "V" or mode == "" then
            local start_line = vim.fn.line("v")
            local end_line = vim.fn.line(".")

            if start_line > end_line then
              start_line, end_line = end_line, start_line
            end

            print(string.format("%d,%dGH", start_line, end_line))
            vim.api.nvim_exec2(string.format("%d,%dGH", start_line, end_line), {})
            print(string.format("GitHub %d-%d line copied to clipboard", start_line, end_line))
          else
            -- Call GH command for the current line in normal mode
            vim.api.nvim_exec2("GH", {})
            print("GitHub line copied to clipboard")
          end
        end,
        mode = { "n", "v", "x" },
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
