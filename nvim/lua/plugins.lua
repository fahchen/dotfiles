local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
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

  use { 'arcticicestudio/nord-vim', branch = 'main' } -- Nord colorscheme
  use { 'cocopon/iceberg.vim' }
  -- UI to select things (files, grep results, open buffers...)
  use {
    'nvim-telescope/telescope.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function() require('telescope').setup {
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
	     fuzzy = false, -- false will only do exact matching
	     override_generic_sorter = false, -- override the generic sorter
	     override_file_sorter = false, -- override the file sorter
	     case_mode = "smart_case", -- or "ignore_case" or "respect_case"
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
    requires = {'kyazdani42/nvim-web-devicons', opt = true},
    config = function()
      require'lualine'.setup {
	options = {
	  icons_enabled = true,
	  theme = 'nord',
	  section_separators = '',
	  component_separators = '',
	  disabled_filetypes = {},
	  always_divide_middle = true,
	},
	sections = {
	  lualine_a = {'mode'},
	  lualine_b = {'diff', 'diagnostics'},
	  lualine_c = {{
	    'filename',
	    file_status = true, -- displays file status (readonly status, modified status)
	    path = 1 -- 0 = just filename, 1 = relative path, 2 = absolute path
	  }},
	  lualine_x = {
	    { 'diagnostics', sources = {'nvim_diagnostic'}, symbols = {error = '? ', warn = '? ', info = '? ', hint = '? '} },
	    'filetype'
	  },
	  lualine_y = {'progress'},
	  lualine_z = {'location'}
	},
	inactive_sections = {
	  lualine_a = {},
	  lualine_b = {'diff'},
	  lualine_c = {{
	    'filename',
	    file_status = true, -- displays file status (readonly status, modified status)
	    path = 1 -- 0 = just filename, 1 = relative path, 2 = absolute path
	  }},
	  lualine_x = {'filetype'},
	  lualine_y = {},
	  lualine_z = {}
	},
	tabline = {},
	extensions = {'fugitive'}
      }
    end
  }

  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons', -- for file icon
    },
    cmd = {
      "NvimTreeToggle",
      "NvimTreeFind",
    },
    config = function() require'nvim-tree'.setup {
      disable_netrw = true,
      hijack_netrw = true,
      update_cwd = true,
      open_on_tab = true,
      view = {
	number = true,
        relativenumber = true,
        preserve_window_proportions = true,
        mappings = {
          custom_only = false,
          list = {
            {
              key = "+",
              action = "increase_width",
              action_cb = function() require'nvim-tree.view'.resize("+5") end,
            },
            {
              key = "-",
              action = "decrease_width",
              action_cb = function() require'nvim-tree.view'.resize("-5") end,
            },
          },
        },
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
	custom = {"^node-modules/", "^_build/", "^deps/", "^\\.git/"},
        exclude = {"dev.exs", "prod.exs", "test.exs"}
      }
    } end
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
      require'nvim-treesitter.configs'.setup {
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
  use 'JoosepAlviste/nvim-ts-context-commentstring'

  use { 'neovim/nvim-lspconfig' } -- Collection of configurations for built-in LSP client
  use { 'hrsh7th/nvim-cmp' }
  use { 'hrsh7th/cmp-nvim-lsp' }
  use { 'hrsh7th/cmp-buffer' }
  use { 'hrsh7th/cmp-path' }
  use { 'saadparwaiz1/cmp_luasnip' }
  use { 'L3MON4D3/LuaSnip' }

  use { 'tpope/vim-fugitive' } -- Git commands in nvim
  use { 'airblade/vim-gitgutter' }

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
    config = function() require('nvim_comment').setup {
      comment_empty = false,
      create_mappings = false,
      hook = function()
        require("ts_context_commentstring.internal").update_commentstring()
      end,
    } end
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
local nvim_lsp = require'lspconfig'
local util = require 'lspconfig.util'
local protocol = require'vim.lsp.protocol'

vim.diagnostic.config({
  virtual_text = false,
  update_in_insert = true,
})

local on_attach = function(client, bufnr)
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

  vim.cmd [[ command! Format execute 'lua vim.lsp.buf.format()' ]]

  if client.name == "eslint" then
    vim.api.nvim_command [[autocmd BufWritePre *.tsx,*.ts,*.jsx,*.js,*.vue EslintFixAll]]
  end

  if client.name ~= "tsserver" and client.name ~= "volar" then
    -- formatting
    if client.server_capabilities.documentFormattingProvider then
      vim.api.nvim_command [[augroup Format]]
      vim.api.nvim_command [[autocmd! * <buffer>]]
      vim.api.nvim_command [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format({ async = false })]]
      vim.api.nvim_command [[augroup END]]
    end
  end

    --protocol.SymbolKind = { }
  protocol.CompletionItemKind = {
    '', -- Text
    '', -- Method
    '', -- Function
    '', -- Constructor
    '', -- Field
    '', -- Variable
    '', -- Class
    'ﰮ', -- Interface
    '', -- Module
    '', -- Property
    '', -- Unit
    '', -- Value
    '', -- Enum
    '', -- Keyword
    '﬌', -- Snippet
    '', -- Color
    '', -- File
    '', -- Reference
    '', -- Folder
    '', -- EnumMember
    '', -- Constant
    '', -- Struct
    '', -- Event
    'ﬦ', -- Operator
    '', -- TypeParameter
  }
end

-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Enable the following language servers
local servers = { "tsserver", "rls", "rust_analyzer", "html", "jsonls", "cssls", "tailwindcss", "sqlls" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

nvim_lsp.eslint.setup{
  on_attach = on_attach,
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

local function get_typescript_server_path(root_dir)
  local global_ts = '/Users/fahchen/Library/pnpm/global/5/node_modules/typescript/lib'
  local found_ts = ''
  local function check_dir(path)
    found_ts =  util.path.join(path, 'node_modules', 'typescript', 'lib')
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

nvim_lsp.volar.setup{
  on_attach = on_attach,
  capabilities = capabilities,
  on_new_config = function(new_config, new_root_dir)
    new_config.init_options.typescript.tsdk = get_typescript_server_path(new_root_dir)
  end,
}

nvim_lsp.elixirls.setup{
  cmd = { "/Users/fahchen/.dev-tools/elixir-ls/release/language_server.sh" },
  on_attach = on_attach,
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
vim.o.completeopt = 'menuone,noselect'

-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'
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
}
