local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim',
    install_path })
end

vim.cmd [[
  augroup Packer
    autocmd!
    autocmd BufWritePost lua/*.lua PackerCompile
  augroup end
]]

local use = require('packer').use

require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim' -- Package manager

  -- theme
  use {
    'embark-theme/vim',
    as = 'embark',
    config = function()
      vim.cmd('colorscheme embark')
    end
  }
  use { 'cocopon/iceberg.vim' }
  -- UI to select things (files, grep results, open buffers...)
  use {
    'nvim-telescope/telescope.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('telescope').setup {
        defaults = {
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
          },
          initial_mode = "insert",
          sorting_strategy = "ascending",
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
              results_width = 0.8,
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          file_sorter = require("telescope.sorters").get_fuzzy_file,
          file_ignore_patterns = { "/node_modules/", "/deps/", "/_build/", "/.git/" },
          generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
          path_display = { "truncate" },
          winblend = 0,
          color_devicons = true,
          use_less = true,
          set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
          file_previewer = require("telescope.previewers").vim_buffer_cat.new,
          grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
          qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
          -- Developer configurations: Not meant for general override
          buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
        },
        extensions = {
          fzf = {
            fuzzy = false,                   -- false will only do exact matching
            override_generic_sorter = false, -- override the generic sorter
            override_file_sorter = false,    -- override the file sorter
            case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
          },
          media_files = {
            filetypes = { "png", "webp", "jpg", "jpeg" },
            find_cmd = "rg", -- find command (defaults to `fd`)
          },
          dash = {
            -- search engine to fall back to when Dash has no results, must be one of: 'ddg', 'duckduckgo', 'startpage', 'google'
            search_engine = 'google',
            -- debounce while typing, in milliseconds
            debounce = 0,
            -- map filetype strings to the keywords you've configured for docsets in Dash
            -- setting to false will disable filtering by filetype for that filetype
            -- filetypes not included in this table will not filter the query by filetype
            -- check src/lua_bindings/dash_config_binding.rs to see all defaults
            -- the values you pass for file_type_keywords are merged with the defaults
            -- to disable filtering for all filetypes,
            -- set file_type_keywords = false
            file_type_keywords = {
              elixir = { 'el', 'erl', 'elixir', 'erlang', 'ecto' },
              javascript = { 'js', 'node', 'javascript', 'typescript', 'ts' },
            },
          },
        },
      }
    end
  }
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = function()
      require 'lualine'.setup {
        options = {
          icons_enabled = true,
          theme = 'nord',
          section_separators = '',
          component_separators = '',
          disabled_filetypes = {},
          always_divide_middle = true,
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'diff', 'diagnostics' },
          lualine_c = { {
            'filename',
            file_status = true, -- displays file status (readonly status, modified status)
            path = 1            -- 0 = just filename, 1 = relative path, 2 = absolute path
          } },
          lualine_x = {
            {
              'diagnostics',
              sources = { 'nvim_diagnostic' },
              symbols = { error = '? ', warn = '? ', info = '? ', hint = '? ' }
            },
            'filetype'
          },
          lualine_y = { 'progress' },
          lualine_z = { 'location' }
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = { 'diff' },
          lualine_c = { {
            'filename',
            file_status = true, -- displays file status (readonly status, modified status)
            path = 1            -- 0 = just filename, 1 = relative path, 2 = absolute path
          } },
          lualine_x = { 'filetype' },
          lualine_y = {},
          lualine_z = {}
        },
        tabline = {},
        extensions = { 'fugitive' }
      }
    end
  }

  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- for file icon
    },
    cmd = {
      "NvimTreeToggle",
      "NvimTreeFind",
    },
    config = function()
      require("nvim-tree").setup({
        disable_netrw = true,
        hijack_netrw = true,
        update_cwd = true,
        open_on_tab = true,
        view = {
          number = true,
          relativenumber = true,
          preserve_window_proportions = true,
        },
        renderer = {
          special_files = {
            "Cargo.toml",
            "Makefile",
            "README.md",
            "readme.md",
            "mix.exs",
            "packages.json",
            "Dockerfile",
          }
        },
        filters = {
          custom = { "^node-modules/", "^_build/", "^deps/", "^\\.git/" },
          exclude = { "dev.exs", "prod.exs", "test.exs" }
        },
        on_attach = function(bufnr)
          local api = require('nvim-tree.api')
          local view = require "nvim-tree.view"

          local function opts(desc)
            return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
          end

          -- BEGIN_DEFAULT_ON_ATTACH
          vim.keymap.set('n', '<C-]>', api.tree.change_root_to_node, opts('CD'))
          vim.keymap.set('n', '<C-e>', api.node.open.replace_tree_buffer, opts('Open: In Place'))
          vim.keymap.set('n', '<C-k>', api.node.show_info_popup, opts('Info'))
          vim.keymap.set('n', '<C-r>', api.fs.rename_sub, opts('Rename: Omit Filename'))
          vim.keymap.set('n', '<C-t>', api.node.open.tab, opts('Open: New Tab'))
          vim.keymap.set('n', '<C-v>', api.node.open.vertical, opts('Open: Vertical Split'))
          vim.keymap.set('n', '<C-x>', api.node.open.horizontal, opts('Open: Horizontal Split'))
          vim.keymap.set('n', '<BS>', api.node.navigate.parent_close, opts('Close Directory'))
          vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Open'))
          vim.keymap.set('n', '<Tab>', api.node.open.preview, opts('Open Preview'))
          vim.keymap.set('n', '>', api.node.navigate.sibling.next, opts('Next Sibling'))
          vim.keymap.set('n', '<', api.node.navigate.sibling.prev, opts('Previous Sibling'))
          vim.keymap.set('n', '.', api.node.run.cmd, opts('Run Command'))
          vim.keymap.set('n', '-', api.tree.change_root_to_parent, opts('Up'))
          vim.keymap.set('n', 'a', api.fs.create, opts('Create'))
          vim.keymap.set('n', 'bmv', api.marks.bulk.move, opts('Move Bookmarked'))
          vim.keymap.set('n', 'B', api.tree.toggle_no_buffer_filter, opts('Toggle No Buffer'))
          vim.keymap.set('n', 'c', api.fs.copy.node, opts('Copy'))
          vim.keymap.set('n', 'C', api.tree.toggle_git_clean_filter, opts('Toggle Git Clean'))
          vim.keymap.set('n', '[c', api.node.navigate.git.prev, opts('Prev Git'))
          vim.keymap.set('n', ']c', api.node.navigate.git.next, opts('Next Git'))
          vim.keymap.set('n', 'd', api.fs.remove, opts('Delete'))
          vim.keymap.set('n', 'D', api.fs.trash, opts('Trash'))
          vim.keymap.set('n', 'E', api.tree.expand_all, opts('Expand All'))
          vim.keymap.set('n', 'e', api.fs.rename_basename, opts('Rename: Basename'))
          vim.keymap.set('n', ']e', api.node.navigate.diagnostics.next, opts('Next Diagnostic'))
          vim.keymap.set('n', '[e', api.node.navigate.diagnostics.prev, opts('Prev Diagnostic'))
          vim.keymap.set('n', 'F', api.live_filter.clear, opts('Clean Filter'))
          vim.keymap.set('n', 'f', api.live_filter.start, opts('Filter'))
          vim.keymap.set('n', 'g?', api.tree.toggle_help, opts('Help'))
          vim.keymap.set('n', 'gy', api.fs.copy.absolute_path, opts('Copy Absolute Path'))
          vim.keymap.set('n', 'H', api.tree.toggle_hidden_filter, opts('Toggle Dotfiles'))
          vim.keymap.set('n', 'I', api.tree.toggle_gitignore_filter, opts('Toggle Git Ignore'))
          vim.keymap.set('n', 'J', api.node.navigate.sibling.last, opts('Last Sibling'))
          vim.keymap.set('n', 'K', api.node.navigate.sibling.first, opts('First Sibling'))
          vim.keymap.set('n', 'm', api.marks.toggle, opts('Toggle Bookmark'))
          vim.keymap.set('n', 'o', api.node.open.edit, opts('Open'))
          vim.keymap.set('n', 'O', api.node.open.no_window_picker, opts('Open: No Window Picker'))
          vim.keymap.set('n', 'p', api.fs.paste, opts('Paste'))
          vim.keymap.set('n', 'P', api.node.navigate.parent, opts('Parent Directory'))
          vim.keymap.set('n', 'q', api.tree.close, opts('Close'))
          vim.keymap.set('n', 'r', api.fs.rename, opts('Rename'))
          vim.keymap.set('n', 'R', api.tree.reload, opts('Refresh'))
          vim.keymap.set('n', 's', api.node.run.system, opts('Run System'))
          vim.keymap.set('n', 'S', api.tree.search_node, opts('Search'))
          vim.keymap.set('n', 'U', api.tree.toggle_custom_filter, opts('Toggle Hidden'))
          vim.keymap.set('n', 'W', api.tree.collapse_all, opts('Collapse'))
          vim.keymap.set('n', 'x', api.fs.cut, opts('Cut'))
          vim.keymap.set('n', 'y', api.fs.copy.filename, opts('Copy Name'))
          vim.keymap.set('n', 'Y', api.fs.copy.relative_path, opts('Copy Relative Path'))
          vim.keymap.set('n', '<2-LeftMouse>', api.node.open.edit, opts('Open'))
          vim.keymap.set('n', '<2-RightMouse>', api.tree.change_root_to_node, opts('CD'))
          -- END_DEFAULT_ON_ATTACH

          vim.keymap.set('n', '+', function()
            view.resize("+5")
          end, opts('increase_width'))

          vim.keymap.set('n', '-', function()
            view.resize("-5")
          end, opts('decrease_width'))
        end,
      })
    end,
  }

  use {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup {
      }
    end
  }

  use 'dstein64/vim-win'
  use 'wsdjeg/vim-fetch'

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require 'nvim-treesitter.configs'.setup {
        ensure_installed = {
          "lua",
          "elixir",
          "vue",
          "html",
          "css",
          "javascript",
          "typescript",
          "go",
          "rust",
          "ruby",
          "json",
          "toml",
          "yaml",
        },
        sync_install = false,
        highlight = {
          enable = true,
          use_languagetree = true,
          additional_vim_regex_highlighting = false,
        },
        incremental_selection = { enable = true },
        textobjects = {
          select = {
            enable = true,
            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["af"] = "@function.outer",
              ["ac"] = "@block.inner",
              ["ic"] = "@block.outer",
            },
          },
        },
        context_commentstring = {
          enable = true,
          config = {
            elixir = '# %s',
            eelixir = '<%# %s %>',
            heex = '{!-- %s --}',
          },
        },
      }
    end
  }
  use 'nvim-treesitter/nvim-treesitter-textobjects'
  use 'nvim-treesitter/nvim-treesitter-context'
  use 'JoosepAlviste/nvim-ts-context-commentstring'

  use { 'neovim/nvim-lspconfig' } -- Collection of configurations for built-in LSP client

  -- Autocompletion framework
  use("hrsh7th/nvim-cmp")
  use({
    -- cmp LSP completion
    "hrsh7th/cmp-nvim-lsp",
    -- cmp Snippet completion
    "hrsh7th/cmp-vsnip",
    -- cmp Path completion
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-cmdline",
    after = { "hrsh7th/nvim-cmp" },
    requires = { "hrsh7th/nvim-cmp" },
  })

  use { 'saadparwaiz1/cmp_luasnip' }
  use { 'L3MON4D3/LuaSnip' }

  -- Snippet engine
  use('hrsh7th/vim-vsnip')

  use('ruanyl/vim-gh-line')

  use('github/copilot.vim')

  -- language
  use("simrat39/rust-tools.nvim")

  use { 'tpope/vim-fugitive' } -- Git commands in nvim
  use { 'airblade/vim-gitgutter' }

  use { 'nvim-tree/nvim-web-devicons' }

  use {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup {
        mode = "document_diagnostics",
      }
    end
  }

  use {
    "terrortylor/nvim-comment",
    cmd = "CommentToggle",
    config = function()
      require('nvim_comment').setup {
        comment_empty = false,
        create_mappings = false,
        hook = function()
          require("ts_context_commentstring.internal").update_commentstring()
        end,
      }
    end
  }

  use { "lambdalisue/suda.vim" }

  use { "arthurxavierx/vim-caser" }
  use { "tpope/vim-surround" }

  use {
    'mrjones2014/dash.nvim',
    run = 'make install',
  }

  if packer_bootstrap then
    require('packer').sync()
  end
end)


-- LSP settings
local nvim_lsp = require 'lspconfig'
local util = require 'lspconfig.util'

vim.diagnostic.config({
  virtual_text = false,
  update_in_insert = true,
})

local default_on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>k', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>j', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>fm', '<cmd>lua vim.lsp.buf.format()<CR>', opts)
end

local formatting_callback = function(client, bufnr)
  local formatting_auid = vim.api.nvim_create_augroup("Formatting", {
    clear = true
  })

  vim.api.nvim_create_autocmd("BufWritePre", {
    group = formatting_auid,
    buffer = bufnr,
    callback = function()
      vim.lsp.buf.format({ async = false })
    end
  })
end

local common_on_attach = function(client, bufnr)
  default_on_attach(client, bufnr)
  formatting_callback(client, bufnr)
end

-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Enable the following language servers
local servers = { "rust_analyzer", "html", "jsonls", "cssls", "tailwindcss", "sqlls", "bashls", "gopls", "lua_ls" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = common_on_attach,
    capabilities = capabilities,
  }
end

nvim_lsp.eslint.setup {
  on_attach = function(client, bufnr)
    default_on_attach(client, bufnr)

    -- formatting
    local formatting_auid = vim.api.nvim_create_augroup("Formatting", {
      clear = true
    })

    vim.api.nvim_create_autocmd("BufWritePre", {
      group = formatting_auid,
      buffer = bufnr,
      command = "EslintFixAll",
    })
  end,
  capabilities = capabilities,
  settings = {
    packageManager = "pnpm",
    format = {
      enable = false,
    },
    codeActionsOnSave = {
      mode = 'problems',
      enable = true,
    },
  },
}

nvim_lsp.denols.setup {
  on_attach = common_on_attach,
  capabilities = capabilities,
  root_dir = nvim_lsp.util.root_pattern("deno.json", "deno.jsonc", ".jet/queries"),
}

nvim_lsp.tsserver.setup {
  on_attach = default_on_attach,
  capabilities = capabilities,
  root_dir = nvim_lsp.util.root_pattern("package.json"),
  single_file_support = false,
}

local function get_typescript_server_path(root_dir)
  local global_ts = '/Users/fahchen/Library/pnpm/global/5/node_modules/typescript/lib'
  local found_ts = ''
  local function check_dir(path)
    found_ts = util.path.join(path, 'node_modules', 'typescript', 'lib')
    if util.path.exists(found_ts) then
      return path
    end
  end
  if util.search_ancestors(root_dir, check_dir) then
    return found_ts
  else
    return global_ts
  end
end

nvim_lsp.volar.setup {
  on_attach = default_on_attach,
  capabilities = capabilities,
  on_new_config = function(new_config, new_root_dir)
    new_config.init_options.typescript.tsdk = get_typescript_server_path(new_root_dir)
  end,
}

nvim_lsp.elixirls.setup {
  cmd = { "/Users/fahchen/.dev-tools/elixir-ls/release/language_server.sh" },
  on_attach = common_on_attach,
  capabilities = capabilities,
  settings = {
    elixirLS = {
      mixEnv = 'dev',
      fetchDeps = true,
      mixTarget = 'dev',
    }
  }
}

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noinsert,noselect'
-- Avoid showing extra messages when using completion
vim.opt.shortmess = vim.opt.shortmess + "c"

-- Configure LSP through rust-tools.nvim plugin.
-- rust-tools will configure and enable certain LSP features for us.
-- See https://github.com/simrat39/rust-tools.nvim#configuration
local opts = {
  tools = {
    runnables = {
      use_telescope = true,
    },
    inlay_hints = {
      auto = true,
      show_parameter_hints = false,
      parameter_hints_prefix = "",
      other_hints_prefix = "",
    },
  },
  -- all the opts to send to nvim-lspconfig
  -- these override the defaults set by rust-tools.nvim
  -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
  server = {
    -- on_attach is a callback called when the language server attachs to the buffer
    on_attach = common_on_attach,
    settings = {
      -- to enable rust-analyzer settings visit:
      -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
      ["rust-analyzer"] = {
        -- enable clippy on save
        checkOnSave = {
          command = "clippy",
        },
      },
    },
  },
}

require("rust-tools").setup(opts)

-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'

local kind_icons = {
  Text = '',
  Method = '',
  Function = '',
  Constructor = '',
  Field = '',
  Variable = '',
  Class = '',
  Interface = 'ﰮ',
  Module = '',
  Property = '',
  Unit = '',
  Value = '',
  Enum = '',
  Keyword = '',
  Snippet = '﬌',
  Color = '',
  File = '',
  Reference = '',
  Folder = '',
  EnumMember = '',
  Constant = '',
  Struct = '',
  Event = '',
  Operator = 'ﬦ',
  TypeParameter = '',
}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end,
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "nvim_lua" },
    { name = "path" },
  },
  formatting = {
    format = function(entry, vim_item)
      -- Kind icons
      vim_item.kind = string.format('%s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
      -- Source
      vim_item.menu = ({
        buffer = "[Buffer]",
        nvim_lsp = "[LSP]",
        luasnip = "[LuaSnip]",
        nvim_lua = "[Lua]",
        latex_symbols = "[LaTeX]",
      })[entry.source.name]
      return vim_item
    end
  },
  {
    { name = 'buffer' },
  }
}

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})
