local nix_flake_dir = os.getenv("HOME") .. "/nix-config"
local nix_flake = nix_flake_dir .. "/flake.nix"
local username = "dstrobel"
local hostname = "noxus"

---@type vim.lsp.Config
return {
  cmd = { "nixd" },
  filetypes = { "nix" },
  root_markers = { "flake.nix", "flake.lock", ".git" },
  settings = {
    nixd = {
      nixpkgs = {
        expr = 'import (builtins.getFlake "' .. nix_flake .. '").inputs.nixpkgs { }',
      },
      formatting = {
        command = { "alejandra" },
      },
      options = {
        nixos = {
          expr = '(builtins.getFlake "' ..
              nix_flake_dir .. '").nixosConfigurations.\"' .. hostname .. '\".options',
        },
        home_manager = {
          expr = '(builtins.getFlake "' .. nix_flake_dir .. '").homeConfigurations.\"' .. username .. '\".options',
        },
      },
    },
  },
}
