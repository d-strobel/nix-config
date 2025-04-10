-- Enable all LSPs here and place the config to the lsp directory.
vim.lsp.enable({
  "ansiblels",
  "astro",
  "bashls",
  "dockerls",
  "gopls",
  "jsonls",
  "luals",
  "nixd",
  "pyright",
  "rust_analyzer",
  "tailwindcss",
  "terraformls",
  "yamlls",
})

-- LSP auto commands.
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', {}),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

    -- Keymaps
    vim.keymap.set("n", "<leader>d", function()
      if not vim.diagnostic.config().virtual_lines then
        vim.diagnostic.config({ virtual_lines = { current_line = true }, virtual_text = false })
      else
        vim.diagnostic.config({ virtual_lines = false, virtual_text = true })
      end
    end, { desc = "Toogle virtual text and virtual lines diagnostics." })

    -- Auto-format on save.
    if not client:supports_method('textDocument/willSaveWaitUntil')
        and client:supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
        end,
      })
    end

    -- Inlay hints
    if client:supports_method("textDocument/inlayHint") then
      -- Enable by default
      vim.lsp.inlay_hint.enable(true)

      -- Keymap for toggle
      vim.keymap.set("n", '<leader>ih', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
      end, { desc = "Toggle LSP inlay hints" })
    end

    -- Organize Imports
    if client:supports_method("textDocument/codeAction") then
      if vim.bo.filetype == "go" then
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = args.buf,
          callback = function()
            vim.lsp.buf.code_action {
              context = {
                only = { "source.organizeImports" },
                diagnostics = vim.diagnostic.get(),
                triggerKind = 2,
              },
              apply = true,
            }
          end
        })
      end
    end
  end,
})
