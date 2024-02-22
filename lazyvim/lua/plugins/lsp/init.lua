local Util = require("lazyvim.util")

return {
  -- lspconfig
  {
    "neovim/nvim-lspconfig",
    event = "LazyFile",
    dependencies = {
      { "folke/neoconf.nvim", cmd = "Neoconf", config = false, dependencies = { "nvim-lspconfig" } },
      { "folke/neodev.nvim",  opts = {} },
    },
    ---@class PluginLspOpts
    opts = {
      -- LSP Server Settings
      ---@type lspconfig.options
      servers = {
        lua_ls = {
          -- Use this to add any additional keymaps
          -- for specific lsp servers
          ---@type LazyKeysSpec[]
          -- keys = {},
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              completion = {
                callSnippet = "Replace",
              },
            },
          },
        },
        jsonls = {},
        eslint = {
          ---@type LazyKeysSpec[]
          settings = {
            -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
            workingDirectory = { mode = "auto" },
          },
        },
        rust_analyzer = {},
        tsserver = {},
        tailwindcss = {},
        denols = {},
        lexical = {
          filetypes = { "elixir", "eelixir", "heex" },
          cmd = { "/Users/fahchen/Projects/dotfiles/lexical/_build/prod/package/lexical/bin/start_lexical.sh" },
          settings = {},
        },
      },
      -- you can do any additional lsp server setup here
      -- return true if you don't want this server to be setup with lspconfig
      ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
      setup = {
        -- example to setup with typescript.nvim
        -- tsserver = function(_, opts)
        --   require("typescript").setup({ server = opts })
        --   return true
        -- end,
        -- Specify * to use this function as a fallback for any server
        -- ["*"] = function(server, opts) end,
        eslint = function()
          local function get_client(buf)
            return require("lazyvim.util").lsp.get_clients({ name = "eslint", bufnr = buf })[1]
          end

          local formatter = require("lazyvim.util").lsp.formatter({
            name = "eslint: lsp",
            primary = false,
            priority = 200,
            filter = "eslint",
          })

          -- Use EslintFixAll on Neovim < 0.10.0
          if not pcall(require, "vim.lsp._dynamic") then
            formatter.name = "eslint: EslintFixAll"
            formatter.sources = function(buf)
              local client = get_client(buf)
              return client and { "eslint" } or {}
            end
            formatter.format = function(buf)
              local client = get_client(buf)
              if client then
                local diag = vim.diagnostic.get(buf, { namespace = vim.lsp.diagnostic.get_namespace(client.id) })
                if #diag > 0 then
                  vim.cmd("EslintFixAll")
                end
              end
            end
          end

          -- register the formatter with LazyVim
          require("lazyvim.util").format.register(formatter)
        end,
        lexical = function(_, opts)
          local lspconfig = require("lspconfig")
          local configs = require("lspconfig.configs")

          if not configs.lexical then
            configs.lexical = {
              default_config = {
                filetypes = { "elixir", "eelixir", "heex" },
                root_dir = function(fname)
                  return lspconfig.util.root_pattern("mix.exs", ".git")(fname) or vim.loop.os_homedir()
                end,
                -- optional settings
                settings = {},
              },
            }
          end

          lspconfig.lexical.setup(opts)
        end
      },
    },
    ---@param opts PluginLspOpts
    config = function(_, opts)
      if Util.has("neoconf.nvim") then
        local plugin = require("lazy.core.config").spec.plugins["neoconf.nvim"]
        require("neoconf").setup(require("lazy.core.plugin").values(plugin, "opts", false))
      end

      -- setup autoformat
      Util.format.register(Util.lsp.formatter())

      -- setup keymaps
      Util.lsp.on_attach(function(client, buffer)
        require("plugins.lsp.keymaps").on_attach(client, buffer)
      end)

      local register_capability = vim.lsp.handlers["client/registerCapability"]

      vim.lsp.handlers["client/registerCapability"] = function(err, res, ctx)
        local ret = register_capability(err, res, ctx)
        local client_id = ctx.client_id
        ---@type lsp.Client
        local client = vim.lsp.get_client_by_id(client_id)
        local buffer = vim.api.nvim_get_current_buf()
        require("plugins.lsp.keymaps").on_attach(client, buffer)
        return ret
      end

      -- enable inlay_hints
      Util.lsp.on_attach(function(client, buffer)
        if client.supports_method("textDocument/inlayHint") then
          Util.toggle.inlay_hints(buffer, true)
        end
      end)

      local servers = opts.servers
      local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        has_cmp and cmp_nvim_lsp.default_capabilities() or {}
      )

      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})

        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return
          end
        elseif opts.setup["*"] then
          if opts.setup["*"](server, server_opts) then
            return
          end
        end
        require("lspconfig")[server].setup(server_opts)
      end

      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          setup(server)
        end
      end

      if Util.lsp.get_config("denols") and Util.lsp.get_config("tsserver") then
        local is_deno = require("lspconfig.util").root_pattern("deno.json", "deno.jsonc")
        Util.lsp.disable("tsserver", is_deno)
        Util.lsp.disable("denols", function(root_dir)
          if is_deno(root_dir) then
            -- explicitly disable tsserver if the deno root_dir is different from the tsserver root_dir
            Util.lsp.disable("tsserver", function()
              return true
            end)

            return false
          else
            return true
          end
        end)
      end
    end,
  },
}
