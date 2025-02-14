local buf = vim.api.nvim_get_current_buf()

-- Disable legacy syntax highlighting
-- vim.cmd("setlocal syntax=off")

-- Ensure Treesitter is enabled
if not vim.treesitter.highlighter.active[buf] then
  vim.treesitter.start(buf)
end
