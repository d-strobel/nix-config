{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./modules/alacritty.nix
    ./modules/bat.nix
    ./modules/btop.nix
    ./modules/chromium.nix
    ./modules/clipboard.nix
    ./modules/cursor.nix
    ./modules/cosmic.nix
    ./modules/dconf.nix
    ./modules/direnv.nix
    ./modules/eza.nix
    ./modules/font.nix
    ./modules/fish.nix
    ./modules/laser-tools.nix
    ./modules/librewolf.nix
    ./modules/fzf.nix
    ./modules/git.nix
    ./modules/gtk.nix
    ./modules/hyprland.nix
    ./modules/hyprpaper.nix
    ./modules/hypridle.nix
    ./modules/hyprlock.nix
    ./modules/hyprsunset.nix
    ./modules/keychain.nix
    ./modules/kubernetes.nix
    ./modules/mako.nix
    ./modules/neovim.nix
    ./modules/packages.nix
    ./modules/qt.nix
    ./modules/qutebrowser.nix
    ./modules/rofi.nix
    ./modules/starship.nix
    ./modules/spotify.nix
    ./modules/tmux.nix
    ./modules/waybar.nix
    ./modules/wlogout.nix
    ./modules/xdg.nix
    ./modules/zathura.nix
    ./modules/zoxide.nix
  ];

  # Enable flakes
  nix = {
    package = with pkgs; nix;
    settings.experimental-features = ["nix-command" "flakes"];
  };

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "dstrobel";
  home.homeDirectory = "/home/dstrobel";

  # Create directories here that home-manager modules depend on
  home.activation.createDirs =
    lib.hm.dag.entryAfter ["writeBoundary"]
    /*
    bash
    */
    ''
      # Cosmic
      mkdir -p ${config.home.homeDirectory}/.config/cosmic
      # Git
      mkdir -p ${config.home.homeDirectory}/git/github.com/d-strobel
      mkdir -p ${config.home.homeDirectory}/git/github.com/laser-zentrale-de
      mkdir -p ${config.home.homeDirectory}/git/gitlab.com/strobel-iac
      # Sops-nix / age
      mkdir -p ${config.home.homeDirectory}/.config/sops/age
    '';

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
