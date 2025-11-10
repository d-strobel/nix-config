local keymap = vim.keymap.set

-- Remove highlight search
keymap('n', '<ESC>', '<cmd>nohlsearch<cr>')

-- Disable space in normal mode
keymap("n", "<Space>", "<Nop>")

-- keep visual selection when (de)indenting
keymap("v", "<", "<gv")
keymap("v", ">", ">gv")

-- Move multilines in visual mode
keymap("v", "J", ":m '>+1<CR>gv=gv", { silent = true })
keymap("v", "K", ":m '<-2<CR>gv=gv", { silent = true })

-- Centralize while going page up and down
keymap("n", "<C-d>", "<C-d>zz")
keymap("n", "<C-u>", "<C-u>zz")

-- Void registry pasting
keymap("x", "<leader>p", [["_dP]])

-- Copy to system clipboard
keymap({ "n", "v" }, "<leader>y", [["+y]])
keymap("n", "<leader>Y", [["+Y]])

-- Paste form system clipboard
keymap({ "n", "v" }, "<leader>p", [["+p]])
keymap("n", "<leader>P", [["+P]])

-- Paste over currently selected text without yanking it
keymap("v", "p", '"_dP')
keymap("v", "P", '"_dP')

-- Delete to void registry
keymap({ "n", "v" }, "<leader>d", [["_d]])

-- Sarch and replace in current file
keymap("n", "<leader>sr", ":%s/")
keymap("v", "<leader>sr", "y:%s/<C-r>\"", { noremap = true, silent = false })

-- Sarch and replace in quickfix
keymap("n", "<leader>qr", ":cdo :%s/")
keymap("n", "<leader>qR", ":cfdo :%s/")

-- Open Quickfix list
keymap("n", "<leader>qq", "<cmd>copen<CR>")
keymap("n", "<leader>qc", "<cmd>cclose<CR>")

-- Remap cnext and cprev for quickfix lists
keymap('n', '<M-n>', '<cmd>cnext<CR>zz')
keymap('n', '<M-p>', '<cmd>cprev<CR>zz')

-- Navigate drop-down menus
vim.keymap.set("i", "<C-j>", function()
  return vim.fn.pumvisible() == 1 and "<C-n>" or "<C-j>"
end, { expr = true, silent = true })

vim.keymap.set("i", "<C-k>", function()
  return vim.fn.pumvisible() == 1 and "<C-p>" or "<C-k>"
end, { expr = true, silent = true })

-- Accept completion
vim.keymap.set("i", "<C-l>", function()
  return vim.fn.pumvisible() == 1 and "<C-y>" or "<C-l>"
end, { expr = true, silent = true })

vim.keymap.set("i", "<CR>", function()
  if vim.fn.pumvisible() == 1 then
    return "<C-y>"
  else
    return "<CR>"
  end
end, { expr = true, silent = true })

-- Manual autocomplete
vim.keymap.set("i", "<C-Space>", function()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  local before_cursor = line:sub(1, col)

  -- Look if we are in a filepath
  if before_cursor:match("[%./~][%w%._%-/]*$") then
    -- Filepath-Completion
    return "<C-x><C-f>"
  else
    -- Omni-Completion
    return "<C-x><C-o>"
  end
end, { expr = true, silent = true })
