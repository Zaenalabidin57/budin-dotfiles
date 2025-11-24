vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)

if vim.g.neovide then
    vim.o.guifont = "ComicCodeLigaturesNerdFontComplete Nerd Font:h12"
    vim.g.neovide_opacity=0.9
    vim.g.neovide_scroll_animation_length = 0.5
    vim.g.neovide_cursor_animation_length = 0.10
    vim.g.neovide_cursor_trail_size = 0.5
    vim.g.neovide_cursor_vfx_mode = "railgun"
    vim.g.neovide_window_floating_opacity = 0.2
    vim.g.neovide_window_floating_blur = 0
    vim.g.neovide_floating_blur_amount_x = 16.0
    vim.g.neovide_floating_blur_amount_y = 6.0
    vim.g.neovide_scale_factor = 1
    vim.cmd [[
    " system clipboard
    nmap <c-c> "+y
    vmap <c-c> "+y
    nmap <c-v> "+p
    inoremap <c-v> <c-r>+
    cnoremap <c-v> <c-r>+
    " use <c-r> to insert original character without triggering things like auto-pairs
    inoremap <c-r> <c-v>
    "]]
end
