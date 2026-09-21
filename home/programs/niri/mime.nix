{pkgs, ...}: {
  home.packages = [pkgs.kdePackages.okular];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "image/png" = "org.gnome.eog.desktop";
      "image/jpg" = "org.gnome.eog.desktop";
      "image/jpeg" = "org.gnome.eog.desktop";
      "application/pdf" = "org.kde.okular.desktop";
      "video/mp4" = "mpv.desktop";
      "video/webm" = "mpv.desktop";
    };
  };
}
