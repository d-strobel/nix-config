{
  config,
  pkgs,
  ...
}: {
  programs.neovim = {
    enable = true;
    package = with pkgs; neovim-unwrapped;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    withPython3 = true;

    plugins = let
      nvim-treesitter-with-plugins = pkgs.vimPlugins.nvim-treesitter.withPlugins (treesitter-plugins:
        # Define Treesitter grammer here
          with treesitter-plugins; [
            yaml
            xml
            typst
            typescript
            toml
            tmux
            terraform
            ssh_config
            rust
            regex
            python
            promql
            nix
            nginx
            markdown-inline
            markdown
            make
            lua
            latex
            just
            json
            ini
            hyprlang
            html
            helm
            hcl
            gosum
            gomod
            go
            gitignore
            gitcommit
            fish
            editorconfig
            dockerfile
            csv
            css
            c
            bash
            astro
          ]);
    in
      with pkgs.vimPlugins; [
        # Lazy package manager
        lazy-nvim

        # Predefined Treesitter with grammer included
        nvim-treesitter-with-plugins

        # Lazy plugins
        fzf-lua
        blink-cmp
        nvim-lspconfig
        oil-nvim
        cloak-nvim
        rose-pine
        harpoon2
        lazydev-nvim
        nvim-web-devicons
        plenary-nvim
        undotree
        vim-fugitive
        mini-statusline
        friendly-snippets
      ];

    extraLuaConfig =
      /*
      lua
      */
      ''
        vim.g.mapleader = " "
        require("lazy").setup({
          spec = {
            { import = "plugins" },
          },
          performance = {
            reset_packpath = false,
            rtp = {
              reset = false,
              disabled_plugins = {
                "gzip",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
              },
            }
          },
          dev = {
            path = "${pkgs.vimUtils.packDir config.programs.neovim.finalPackage.passthru.packpathDirs}/pack/myNeovimPackages/start",
            patterns = {""},
          },
          install = {
            missing = false,
          },
          ui = { border = "single" },
        })
      '';

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
      ansible-lint

      # Terraform
      terraform-ls

      # Bash
      bash-language-server

      # Rust
      rust-analyzer

      # Go
      gopls

      # Just
      just-lsp

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

  # Nvim config
  home.file."./.config/nvim/plugin" = {
    enable = true;
    source = ../dotfiles/nvim/plugin;
    recursive = true;
  };

  # Lua plugins
  home.file."./.config/nvim/lua" = {
    enable = true;
    source = ../dotfiles/nvim/lua;
    recursive = true;
  };

  # After config
  home.file."./.config/nvim/after" = {
    enable = true;
    source = ../dotfiles/nvim/after;
    recursive = true;
  };

  # LSP configs
  home.file."./.config/nvim/lsp" = {
    enable = true;
    source = ../dotfiles/nvim/lsp;
    recursive = true;
  };
}
