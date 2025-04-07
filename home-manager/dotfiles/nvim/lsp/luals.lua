---@type vim.lsp.Config
return {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = {
    ".luarc.json",
    ".luarc.jsonc",
    ".luacheckrc",
    ".stylua.toml",
    "stylua.toml",
    ".git",
  },
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      signatureHelp = { enabled = true },
      telemetry = { enabled = false },
      workspace = {
        library = vim.tbl_extend(
          "keep",
          { vim.env.VIMRUNTIME, "${3rd}/luv/library" },
          vim.api.nvim_get_runtime_file("", true)
        ),
      },
    },
  },
}
