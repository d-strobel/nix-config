local function enable_treesitter()
  local buf = vim.api.nvim_get_current_buf()
  local lang = vim.treesitter.language.get_lang(vim.bo.filetype)

  -- Check if Treesitter has a parser for this filetype
  if lang and require("nvim-treesitter.parsers").has_parser(lang) then
    -- Disable old syntax highlighting
    vim.cmd("setlocal syntax=off")
    -- Start Treesitter highlighting
    vim.treesitter.start(buf)
  end
end

-- Enable Treesitter when opening any buffer
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  callback = enable_treesitter,
})
