{
  cfg,
  config,
  pkgs,
  ...
}: let
  # Custom symlinking
  mkSymlinkAttrs = import ../../lib/mkSymlinkAttrs.nix {
    inherit pkgs;
    inherit (cfg) context runtimeRoot;
    hm = config.lib;
  };
in {
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
            java
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

      # Custom plugin colortheme Alabaster-nvim
      alabaster-nvim = pkgs.vimUtils.buildVimPlugin {
        pname = "alabaster.nvim";
        version = "main";
        src = pkgs.fetchgit {
          url = "https://git.sr.ht/~p00f/alabaster.nvim";
          rev = "b14f4527bd5d5528cac33599f71ad542c2f38748";
          sha256 = "sha256-W9F9cWJfBglZ92W9h4uaVe7vENCf0wWDK0vr4U5LePU=";
        };
      };
    in
      with pkgs.vimPlugins; [
        # Lazy package manager
        lazy-nvim

        # Predefined Treesitter with grammer included
        nvim-treesitter-with-plugins

        # Lazy plugins
        nvim-lspconfig
        fzf-lua
        oil-nvim
        cloak-nvim
        harpoon2
        lazydev-nvim
        nvim-web-devicons
        plenary-nvim
        undotree
        vim-fugitive
        friendly-snippets

        # Custom plugins
        alabaster-nvim
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

        vim.cmd("colorscheme alabaster")
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
      # ansible-language-server
      ansible-lint

      # Terraform
      terraform-ls

      # Opentofu
      tofu-ls

      # Bash
      bash-language-server

      # Rust
      rust-analyzer

      # Go
      gopls

      # Java
      jdt-language-server

      # Just
      just-lsp

      # Json
      jsonschema
      nodePackages.vscode-json-languageserver

      # Yaml
      yaml-language-server

      # Docker
      dockerfile-language-server

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

  home.file = mkSymlinkAttrs {
    # Nvim config
    "./.config/nvim/plugin" = {
      source = ../dotfiles/nvim/plugin;
      outOfStoreSymlink = true;
      recursive = true;
    };

    # Lua plugins
    "./.config/nvim/lua" = {
      source = ../dotfiles/nvim/lua;
      outOfStoreSymlink = true;
      recursive = true;
    };

    # After config
    "./.config/nvim/after" = {
      source = ../dotfiles/nvim/after;
      outOfStoreSymlink = true;
      recursive = true;
    };

    # LSP configs
    "./.config/nvim/lsp" = {
      source = ../dotfiles/nvim/lsp;
      outOfStoreSymlink = true;
      recursive = true;
    };
  };
}
