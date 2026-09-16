{pkgs, ...}: {
  home.packages = [pkgs.matugen];

  xdg.configFile."matugen/config.toml".text = ''
    [config]

    [templates.niri]
    input_path = '~/.config/matugen/templates/niri-colors.kdl'
    output_path = '~/.config/niri/colors.kdl'

    [templates.waybar]
    input_path = '~/.config/matugen/templates/colors.css'
    output_path = '~/.config/waybar/colors.css'

    [templates.gtk3]
    input_path = '~/.config/matugen/templates/gtk-colors.css'
    output_path = '~/.config/gtk-3.0/colors.css'

    [templates.gtk4]
    input_path = '~/.config/matugen/templates/gtk-colors.css'
    output_path = '~/.config/gtk-4.0/colors.css'
  '';
  xdg.configFile."matugen/templates/niri-colors.kdl".text = ''
    layout {
      focus-ring {
        active-color "{{colors.primary.default.hex}}"
        inactive-color "{{colors.outline.default.hex}}"
        urgent-color "{{colors.error.default.hex}}"
      }
      border {
        active-color "{{colors.primary.default.hex}}"
        inactive-color "{{colors.outline.default.hex}}"
        urgent-color "{{colors.error.default.hex}}"
      }
      shadow { color "{{colors.shadow.default.hex}}70" }
    }
  '';
  xdg.configFile."matugen/templates/colors.css".text = ''
    <* for name, value in colors *>
    @define-color {{name}} {{value.default.hex}};
    <* endfor *>
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
