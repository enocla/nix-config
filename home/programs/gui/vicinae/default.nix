{
  config,
  lib,
  theme,
  vicinae,
  ...
}: let
  c = theme.colors;
  inherit (theme.ui) cornerRadius fontFamily;
  xdgDataDirs = lib.concatStringsSep ":" [
    "${config.home.homeDirectory}/.nix-profile/share"
    "/nix/var/nix/profiles/default/share"
    "/run/current-system/sw/share"
  ];
in {
  imports = [vicinae.homeManagerModules.default];

  # The user service does not inherit NixOS's login-session environment. Include
  # the system profile so Vicinae can discover desktop entries such as Obsidian.
  systemd.user.services.vicinae.Service.Environment = [
    "XDG_DATA_DIRS=${xdgDataDirs}"
  ];

  programs.vicinae = {
    enable = true;
    systemd.enable = true;

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

    themes.nix-config = {
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
        list.item.selection = {
          background = c.surface1;
          secondary_background = c.surface0;
        };
        grid.item.background = c.surface0;
      };
    };
  };
}
