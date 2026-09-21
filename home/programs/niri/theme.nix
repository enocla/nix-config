{
  config,
  lib,
  pkgs,
  theme,
  ...
}: let
  c = theme.colors;
  inherit (theme.ui) fontFamily monospaceFontFamily;
  wallpaper = ../../../extra/wallpaper/phos.webp;
  gtkFallbackCss = ''
    @define-color accent_color ${c.mauve};
    @define-color accent_fg_color ${c.crust};
    @define-color accent_bg_color ${c.mauve};
    @define-color window_bg_color ${c.base};
    @define-color window_fg_color ${c.text};
    @define-color view_bg_color ${c.base};
    @define-color view_fg_color ${c.text};
  '';
in {
  home.packages = [pkgs.pywal];

  # Matugen owns these mutable files after a wallpaper change. The activation
  # fallback only initializes a missing file, so it never replaces Matugen's
  # runtime output or creates a store-managed path.
  home.activation.matugenGtkFallback = lib.hm.dag.entryAfter ["writeBoundary"] ''
    for gtk_version in 3.0 4.0; do
      colors_file="${config.xdg.configHome}/gtk-$gtk_version/colors.css"
      if [ ! -e "$colors_file" ] && [ ! -L "$colors_file" ]; then
        run ${pkgs.coreutils}/bin/mkdir -p "$(dirname "$colors_file")"
        run ${pkgs.coreutils}/bin/tee "$colors_file" >/dev/null <<'EOF'
    ${gtkFallbackCss}
    EOF
      fi
    done
  '';

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
    gtk3.extraCss = ''
      @import url("file://${config.xdg.configHome}/gtk-3.0/colors.css");
    '';
    gtk4.extraCss = ''
      @import url("file://${config.xdg.configHome}/gtk-4.0/colors.css");
    '';
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
