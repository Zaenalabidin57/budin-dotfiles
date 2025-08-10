require "nvchad.options"

require("telescope").load_extension "harpoon"
require("telescope").load_extension 'zoxide'

if vim.g.neovide then
  vim.keymap.set('n', '<D-s>', ':w<CR>') -- Save
  vim.keymap.set('v', '<D-c>', '"+y') -- Copy
  vim.keymap.set('n', '<D-v>', '"+P') -- Paste normal mode
  vim.keymap.set('v', '<D-v>', '"+P') -- Paste visual mode
  vim.keymap.set('c', '<D-v>', '<C-R>+') -- Paste command mode
  vim.keymap.set('i', '<D-v>', '<ESC>l"+Pli') -- Paste insert mode

  vim.g.neovide_scale_factor = 1.0
end


-- vim.cmd "highlight! HarpoonInactive guibg=NONE guifg=#63698c"
-- vim.cmd "highlight! HarpoonActive guibg=NONE guifg=white"
-- vim.cmd "highlight! HarpoonNumberActive guibg=NONE guifg=#7aa2f7"
-- vim.cmd "highlight! HarpoonNumberInactive guibg=NONE guifg=#7aa2f7"
-- vim.cmd "highlight! TabLineFill guibg=NONE guifg=white"

-- add yours here!

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
