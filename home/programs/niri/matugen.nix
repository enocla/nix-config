{pkgs, ...}: {
  home.packages = [pkgs.matugen];

  # The shared Nix palette owns Niri and Waybar. Matugen remains available for
  # the wallpaper hook, but only its GTK output is generated here so runtime
  # wallpaper changes cannot silently replace the declarative desktop colors.
  xdg.configFile."matugen/config.toml".text = ''
    [config]

    [templates.gtk3]
    input_path = '~/.config/matugen/templates/gtk-colors.css'
    output_path = '~/.config/gtk-3.0/colors.css'

    [templates.gtk4]
    input_path = '~/.config/matugen/templates/gtk-colors.css'
    output_path = '~/.config/gtk-4.0/colors.css'
  '';
  xdg.configFile."matugen/templates/gtk-colors.css".text = ''
    @define-color accent_color {{colors.primary_fixed_dim.default.rgba}};
    @define-color accent_fg_color {{colors.on_primary_fixed.default.rgba}};
    @define-color accent_bg_color {{colors.primary_fixed_dim.default.rgba}};
    @define-color window_bg_color {{colors.surface_dim.default.rgba}};
    @define-color window_fg_color {{colors.on_surface.default.rgba}};
    @define-color view_bg_color {{colors.surface.default.rgba}};
    @define-color view_fg_color {{colors.on_surface.default.rgba}};
  '';
}
