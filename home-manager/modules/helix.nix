{pkgs, ...}: {
  programs.helix = {
    enable = true;
    package = with pkgs; evil-helix;
    extraPackages = with pkgs; [
      # Needed for Treesitter
      gcc

      # Lua
      lua-language-server

      # Nix
      nixd
      alejandra

      # Ansible
      ansible-language-server

      # Terraform
      terraform-ls

      # Bash
      bash-language-server

      # Rust
      rust-analyzer

      # Go
      gopls

      # Json
      jsonschema
      nodePackages.vscode-json-languageserver

      # Yaml
      yaml-language-server

      # Docker
      dockerfile-language-server-nodejs

      # Astro Web Framework
      astro-language-server

      # CSS
      tailwindcss-language-server

      # Python
      pyright

      # Fish
      fish-lsp

      # SQL
      postgres-lsp

      # Typst
      tinymist
    ];
  };
}
