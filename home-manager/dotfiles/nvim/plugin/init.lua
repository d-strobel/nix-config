-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Diagnostic config
vim.diagnostic.config({
  virtual_text = true,
})

-- Filetypes
vim.filetype.add({
  extension = {
    -- Terraform
    tf = "terraform",
    tfvars = "terraform",
    tfbackend = "config",
    tfstate = "json",
    -- Systemd
    service = "systemd",
    timer = "systemd",
  }
})
