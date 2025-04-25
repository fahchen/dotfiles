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
  {
    "mistricky/codesnap.nvim",
    build = "make",
    keys = {
      { "<leader>tc", "<cmd>CodeSnapHighlight<cr>", mode = "x", desc = "Save selected code snapshot into clipboard" },
      {
        "<leader>ts",
        "<cmd>CodeSnapSaveHighlight<cr>",
        mode = "x",
        desc = "Save selected code snapshot in ~/Screenshots",
      },
    },
    opts = {
      save_path = "~/Screenshots/",
      has_breadcrumbs = true,
      show_workspace = true,
      has_line_number = true,
      code_font_family = "Maple Mono NF CN",
      watermark_font_family = "Maple Mono NF CN",
      watermark = "@Phil Chen",
      bg_theme = "bamboo",
      bg_color = "#535c68",
    },
  },
}
