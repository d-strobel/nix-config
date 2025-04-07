---@type vim.lsp.Config
return {
  cmd = { "rust-analyzer" },
  root_markers = { "Cargo.toml", "Cargo.lock", "build.rs" },
  filetypes = { "rust", "toml.Cargo" },
  capabilities = {
    experimental = {
      serverStatusNotification = true,
    },
  },
  settings = {
    ["rust-analyzer"] = {
      diagnostics = {
        styleLints = { enable = true },
      },
      checkOnSave = true,
      check = {
        command = "clippy",
        features = "all",
        allTargets = true,
      },
      cargo = {
        buildScripts = { enable = true },
        features = "all",
      },
      procMacro = { enable = true },
      imports = {
        group = { enable = false },
        granularity = { group = "module" },
        prefix = "self",
      },
      completion = {
        postfix = { enable = true },
      },
    },
  },
}
