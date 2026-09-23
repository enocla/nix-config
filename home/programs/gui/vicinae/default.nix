{
  config,
  host,
  inputs,
  lib,
  theme,
  ...
}: let
  c = theme.colors;
  inherit (theme.ui) cornerRadius fontFamily;
  isLinux = lib.hasSuffix "-linux" host.system;
  xdgDataDirs = lib.concatStringsSep ":" [
    "${config.xdg.dataHome}"
    "${host.homeDirectory}/.nix-profile/share"
    "/etc/profiles/per-user/${host.username}/share"
    "/nix/var/nix/profiles/default/share"
    "/run/current-system/sw/share"
  ];
  settings = {
    close_on_focus_loss = true;
    pop_to_root_on_close = true;
    input_server.enabled = false;
    font.normal = {
      family = fontFamily;
      size = 12;
    };
    theme = {
      light = {
        name = "nix-config";
        icon_theme = "auto";
      };
      dark = {
        name = "nix-config";
        icon_theme = "auto";
      };
    };
    launcher_window = {
      opacity = 0.95;
      material = "blur";
      rounding = cornerRadius;
      layer_shell = {
        enabled = true;
        keyboard_interactivity = "exclusive";
        layer = "top";
      };
      client_side_decorations = {
        enabled = true;
        border_width = 1;
        shadow_size = cornerRadius;
      };
    };
  };
  vicinaeTheme = {
    meta = {
      version = 1;
      name = "nix-config";
      description = "Shared nix-config theme";
      variant = "dark";
    };
    colors = {
      core = {
        background = c.base;
        foreground = c.text;
        secondary_background = c.mantle;
        border = c.surface1;
        accent = c.mauve;
      };
      accents = {
        blue = c.blue;
        green = c.green;
        magenta = c.pink;
        orange = c.peach;
        purple = c.mauve;
        red = c.red;
        yellow = c.yellow;
        cyan = c.sky;
      };
    };
    list.item.selection = {
      background = c.surface1;
      secondary_background = c.surface0;
    };
    grid.item.background = c.surface0;
  };
in {
  imports = [inputs.vicinae.homeManagerModules.default];

  programs.vicinae = {
    enable = if isLinux then true else false;
    package = inputs.vicinae.packages.${host.system}.default;

    systemd = {
      enable = isLinux;
      environment = lib.mkIf isLinux {
        XDG_DATA_DIRS = xdgDataDirs;
      };
    };

    launchd.enable = !isLinux;

    inherit settings;
    themes.nix-config = vicinaeTheme;
  };
}
