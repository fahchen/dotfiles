local Util = require("lazyvim.util")

 _G.LazyVim = Util

local M = {}

function M.setup()
  -- autocmds can be loaded lazily when not opening a file
  local lazy_autocmds = vim.fn.argc(-1) == 0
  if not lazy_autocmds then
    M.load("autocmds")
  end

  local group = vim.api.nvim_create_augroup("LazyVim", { clear = true })
  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "VeryLazy",
    callback = function()
      if lazy_autocmds then
        M.load("autocmds")
      end
      M.load("keymaps")

      Util.format.setup()
    end,
  })

  Util.track("colorscheme")
  Util.try(function()
    if type(M.colorscheme) == "function" then
      M.colorscheme()
    else
      vim.cmd.colorscheme(M.colorscheme)
    end
  end, {
    msg = "Could not load your colorscheme",
    on_error = function(msg)
      Util.error(msg)
      vim.cmd.colorscheme("habamax")
    end,
  })
  Util.track()
end

---@param name "autocmds" | "options" | "keymaps"
function M.load(name)
  local function _load(mod)
    if require("lazy.core.cache").find(mod)[1] then
      Util.try(function()
        require(mod)
      end, { msg = "Failed loading " .. mod })
    end
  end

  _load("config." .. name)

  if vim.bo.filetype == "lazy" then
    -- HACK: LazyVim may have overwritten options of the Lazy ui, so reset this here
    vim.cmd([[do VimResized]])
  end
  local pattern = "LazyVim" .. name:sub(1, 1):upper() .. name:sub(2)
  vim.api.nvim_exec_autocmds("User", { pattern = pattern, modeline = false })
end

M.did_init = false
function M.init()
  if M.did_init then
    return
  end
  M.did_init = true
  local plugin = require("lazy.core.config").spec.plugins.LazyVim
  if plugin then
    vim.opt.rtp:append(plugin.dir)
  end

  M.load("options")

  Util.plugin.lazy_file()
end

return M
