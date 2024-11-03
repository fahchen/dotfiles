return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = function()
      return {
        {
          "<c-n>",
          function()
            require("neo-tree.command").execute({
              toggle = true,
              dir = vim.uv.cwd(),
              reveal = true,
              source = "filesystem",
            })
          end,
          desc = "Toggle NeoTree (cwd)",
        },
        {
          "<leader>ef",
          function()
            require("neo-tree.command").execute({ toggle = true, dir = LazyVim.root() })
          end,
          desc = "Explorer NeoTree (Root Dir)",
        },
        {
          "<leader>Ef",
          function()
            require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
          end,
          desc = "Explorer NeoTree (cwd)",
        },
        {
          "<leader>eg",
          function()
            require("neo-tree.command").execute({ toggle = true, source = "git_status" })
          end,
          desc = "Git Explorer",
        },
        {
          "<leader>eb",
          function()
            require("neo-tree.command").execute({ toggle = true, source = "buffers" })
          end,
          desc = "Buffer Explorer",
        },
      }
    end,
    opts = {
      window = {
        position = "float",
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "diff",
        "elixir",
        "erlang",
        "graphql",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "rust",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      },
    },
  },
  {
    "zbirenbaum/copilot.lua",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 200,
        keymap = {
          accept = "<c-v>",
        },
      },
      panel = {
        enabled = true,
        auto_refresh = true,
        keymap = {
          jump_prev = "<c-p>",
          jump_next = "<c-n>",
        },
        layout = {
          position = "right",
        },
      },
      filetypes = {
        help = false,
        sh = function()
          if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), "^%.env.*") then
            -- disable for .env files
            return false
          end
          return true
        end,
        ["*"] = true,
      },
    },
    keys = {
      {
        "<c-c>",
        mode = { "i" },
        function()
          require("copilot.panel").open({ position = "right" })
        end,
      },
    },
  },
  {
    "rafamadriz/friendly-snippets",
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load({ paths = { "./lua/plugins/snippets" } })
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
  {
    "rcarriga/nvim-notify",
    opts = {
      render = "compact",
      top_down = false,
    },
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "biome",
        "eslint-lsp",
        "json-lsp",
        "lexical",
        "lua-language-server",
        "marksman",
        "mdx-analyzer",
        "shfmt",
        "sql-formatter",
        "stylua",
        "tailwindcss-language-server",
        "vtsls",
        "typos",
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        sql = {
          "sql_formatter",
        },
      },
      formatters = {
        sql_formatter = {
          args = {
            "-l",
            "plsql",
          },
        },
      },
    },
  },
}
