local map = function(mode, keys, cmd, opt)
   local options = { noremap = true, silent = true }
   if opt then
      options = vim.tbl_extend("force", options, opt)
   end

   -- all valid modes allowed for mappings
   -- :h map-modes
   local valid_modes = {
      [""] = true,
      ["n"] = true,
      ["v"] = true,
      ["s"] = true,
      ["x"] = true,
      ["o"] = true,
      ["!"] = true,
      ["i"] = true,
      ["l"] = true,
      ["c"] = true,
      ["t"] = true,
   }

   -- helper function for M.map
   -- can gives multiple modes and keys
   local function map_wrapper(mode, lhs, rhs, options)
      if type(lhs) == "table" then
         for _, key in ipairs(lhs) do
            map_wrapper(mode, key, rhs, options)
         end
      else
         if type(mode) == "table" then
            for _, m in ipairs(mode) do
               map_wrapper(m, lhs, rhs, options)
            end
         else
            if valid_modes[mode] and lhs and rhs then
               vim.api.nvim_set_keymap(mode, lhs, rhs, options)
            else
               mode, lhs, rhs = mode or "", lhs or "", rhs or ""
               print("Cannot set mapping [ mode = '" .. mode .. "' | key = '" .. lhs .. "' | cmd = '" .. rhs .. "' ]")
            end
         end
      end
   end

   map_wrapper(mode, keys, cmd, options)
 end

-- NvimTree
map("n", "<c-n>",  ":NvimTreeToggle <CR>")
map("n", "<leader>p",  ":NvimTreeFindFile <CR>")

-- copilot
map("i", "<c-v>", 'copilot#Accept("")', { silent = true, script = true, expr = true, nowait = true })

-- Telescope
map("n", "<leader>gc", [[<cmd>lua require'telescope.builtin'.grep_string()<CR>]]) 
map('n', '<leader>gg', [[<cmd>lua require('telescope.builtin').live_grep()<CR>]])
map("n", "<leader><leader>", [[<cmd>lua require'telescope.builtin'.find_files()<CR>]]) 
map('n', '<leader><Enter>', [[<cmd>lua require('telescope.builtin').buffers()<CR>]])
map('n', '<leader><space>', [[<cmd>lua require('telescope.builtin').git_status()<CR>]])
map('n', '<leader>t', [[<cmd>lua require('telescope.builtin').treesitter()<CR>]])

-- editor
map("i", "<c-s>", "<cmd>:w<CR>")
map("n", "<c-s>", "<cmd>:w<CR>")
map("n", "<leader>x", ":bd<CR>")
map("n", "<leader>q", ":q<CR>")
map("n", "<leader>Q", ":qa!<CR>")

-- lsp
map("n", "<leader>j", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>")
map("n", "<leader>k", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>")
map("n", "<leader>td", "<cmd>TroubleToggle<cr>")


-- misc
map("n", "<c-g>", "<cmd>lua require('functions').copy_file_path()<CR>")

-- comments
map("n", "<leader>/", ":CommentToggle <CR>")
map("v", "<leader>/", ":CommentToggle <CR>")

-- Movement in insert mode
map("i", "<c-h>", "<Left>")
map("i", "<c-e>", "<End>")
map("i", "<c-l>", "<Right>")
map("i", "<c-k>", "<Up>")
map("i", "<c-j>", "<Down>")
map("i", "<c-a>", "<ESC>^i")

-- <tab> / <s-tab> | Circular windows navigation
map("n", "<tab>", "<c-w>w")
map("n", "<S-tab>", "<c-w>W")

-- navigation between windows
map("n", "<c-h>", "<C-w>h")
map("n", "<c-l>", "<C-w>l")
map("n", "<c-k>", "<C-w>k")
map("n", "<c-j>", "<C-w>j")

-- use ESC to turn off search highlighting
map("n", "<Esc>", ":noh <CR>")

-- yank from current cursor to end of line
map("n", "Y", "yg$")
