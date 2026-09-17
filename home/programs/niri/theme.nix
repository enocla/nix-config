{
  pkgs,
  theme,
  ...
}: let
  c = theme.colors;
  inherit (theme.ui) fontFamily monospaceFontFamily;
  wallpaper = ../../../extra/wallpaper/phos.webp;
in {
  home.packages = [pkgs.pywal];

  home.sessionVariables.QS_ICON_THEME = "Papirus-Dark";

  home.file = {
    ".icons/default".source = "${pkgs.bibata-cursors}/share/icons/Bibata-Modern-Classic";
    "Pictures/phos.webp".source = wallpaper;
  };

  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
    icon-theme = "Papirus-Dark";
  };

  gtk = {
    enable = true;
    gtk4.theme = null;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 24;
    };
    font = {
      name = fontFamily;
      size = 13;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
    qt5ctSettings.Fonts = {
      fixed = "\"${monospaceFontFamily},13\"";
      general = "\"${fontFamily},13\"";
    };
    qt6ctSettings.Fonts = {
      fixed = "\"${monospaceFontFamily},13\"";
      general = "\"${fontFamily},13\"";
    };
  };
}
