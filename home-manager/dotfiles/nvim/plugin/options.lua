local opt = vim.opt

-- Line numbers
opt.nu = true
opt.relativenumber = true

-- Linebreak
opt.wrap = false

-- Curser line
opt.cursorline = true

-- Indenting
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

-- Split for replaces
opt.inccommand = "split"

-- Search settings
opt.smartcase = true
opt.ignorecase = true

-- Scrollin
opt.scrolloff = 10

-- split windows
opt.splitright = true
opt.splitbelow = true

-- Undo
opt.undofile = true

-- Swap
opt.swapfile = false

-- Colors
opt.termguicolors = true

-- Window border for floating windows
opt.winborder = 'single'

-- Autocompletion
opt.completeopt = { "menuone", "noselect", "popup" }

-- Statusline
local statusline = require("statusline_hx")
local active, inactive = statusline.statuslines()

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
  callback = function()
    vim.wo.statusline = active
  end,
})
vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
  callback = function()
    vim.wo.statusline = inactive
  end,
})
