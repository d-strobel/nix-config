{config, ...}: {
  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
    };

    mime.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "image/jpeg" = "org.gnome.Loupe.desktop";
        "image/png" = "org.gnome.Loupe.desktop";
        "text/plain" = "org.gnome.TextEditor.desktop";
        "text/html" = "org.gnome.TextEditor.desktop";
        "text/csv" = "org.gnome.TextEditor.desktop";
        "application/pdf" = ["org.pwmt.zathura.desktop" "librewolf.desktop" "chromium-browser.desktop"];
        # "application/zip" = "org.gnome.FileRoller.desktop";
        # "application/x-tar" = "org.gnome.FileRoller.desktop";
        # "application/x-bzip2" = "org.gnome.FileRoller.desktop";
        # "application/x-gzip" = "org.gnome.FileRoller.desktop";
        "x-scheme-handler/http" = ["librewolf.desktop" "chromium-browser.desktop"];
        "x-scheme-handler/https" = ["librewolf.desktop" "chromium-browser.desktop"];
        "x-scheme-handler/about" = ["librewolf.desktop" "chromium-browser.desktop"];
        "x-scheme-handler/unknown" = ["librewolf.desktop" "chromium-browser.desktop"];
        # "x-scheme-handler/mailto" = [""];
        "audio/mp3" = "vlc.desktop";
        "audio/x-matroska" = "vlc.desktop";
        "video/webm" = "vlc.desktop";
        "video/mp4" = "vlc.desktop";
        "video/x-matroska" = "vlc.desktop";
        # "inode/directory" = "pcmanfm.desktop";
      };
    };
  };
}
