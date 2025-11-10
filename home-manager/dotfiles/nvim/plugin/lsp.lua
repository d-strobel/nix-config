-- Enable all LSPs here and place the config to the lsp directory.
vim.lsp.enable({
  "ansiblels",
  "astro",
  "bashls",
  "dockerls",
  "fish_lsp",
  "gopls",
  "jdtls",
  "jsonls",
  "just",
  "luals",
  "nixd",
  "pyright",
  "postgres_lsp",
  "rust_analyzer",
  "tailwindcss",
  "terraformls",
  "tofu_ls",
  "tinymist",
  "yamlls",
})

-- LSP auto commands.
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', {}),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

    -- Keymaps
    vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float)
    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end)

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
      -- Auto organize imports for all go code
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

    -- Omni completion
    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end
  end,
})

-- LspDebug
local function show_lsp_debug_info()
  local bufnr = vim.api.nvim_get_current_buf()
  local bufname = vim.api.nvim_buf_get_name(bufnr)

  local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
  local client_names = {}
  for _, c in ipairs(clients) do
    table.insert(client_names, c.name .. (c.supports_method("textDocument/completion") and " ✓completion" or ""))
  end

  local completion_enabled = false
  if vim.lsp.completion and vim.lsp.completion.is_enabled then
    completion_enabled = vim.lsp.completion.is_enabled(bufnr)
  end

  local omnifunc = vim.api.nvim_buf_get_option(bufnr, "omnifunc")
  local completeopt = vim.o.completeopt

  print("🧾 LSP Debug Info:")
  print("  Buffer: " .. bufnr .. " (" .. bufname .. ")")
  print("  LSP Clients: " .. (#client_names > 0 and table.concat(client_names, ", ") or "none"))
  print("  LSP Completion enabled: " .. tostring(completion_enabled))
  print("  omnifunc: " .. omnifunc)
  print("  completeopt: " .. completeopt)
end

vim.api.nvim_create_user_command("LspDebug", show_lsp_debug_info, {})
