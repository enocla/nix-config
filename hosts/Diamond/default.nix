{
  darwin-custom-icons,
  paneru,
  pkgs,
  username,
  ...
}: {
  imports = [
    ../../modules/base
    ../../modules/darwin
    darwin-custom-icons.darwinModules.default
    paneru.darwinModules.paneru
    ../../modules/icons
  ];

  nixpkgs.config.allowUnfree = true;

  services.paneru = {
    enable = true;
    # Crane's cargoWithProfile helper maps this to `cargo build --release`.
    package = paneru.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (_: {
      CARGO_PROFILE = "release";
    });
    luaConfig.enable = true;
    config = ''
      paneru.setup {
        options = {
          focus_follows_mouse = true,
          mouse_follows_focus = false,
          preset_column_widths = { 0.333, 0.5, 0.667, 0.8 },
          animation_speed = 40.0,
          auto_center = true,
          reap_empty_workspaces = true,
          virtual_workspace_animations = true,
        },

        bindings = {
          ["window focus west"] = "alt + cmd + ctrl - h",
          ["window focus south"] = "alt + cmd + ctrl - j",
          ["window focus north"] = "alt + cmd + ctrl - k",
          ["window focus east"] = "alt + cmd + ctrl - l",
          ["window focus 1"] = "alt + cmd + ctrl - 1",
          ["window focus 2"] = "alt + cmd + ctrl - 2",
          ["window focus 3"] = "alt + cmd + ctrl - 3",
          ["window focus 4"] = "alt + cmd + ctrl - 4",
          ["window focus 5"] = "alt + cmd + ctrl - 5",
          ["window focus 6"] = "alt + cmd + ctrl - 6",
          ["window focus 7"] = "alt + cmd + ctrl - 7",
          ["window focus 8"] = "alt + cmd + ctrl - 8",
          ["window focus 9"] = "alt + cmd + ctrl - 9",
          ["window swap west"] = "alt + cmd + ctrl - leftarrow",
          ["window swap east"] = "alt + cmd + ctrl - rightarrow",
          ["window swap north"] = "alt + cmd + ctrl - uparrow",
          ["window swap south"] = "alt + cmd + ctrl - downarrow",
          ["window center"] = "alt - c",
          ["window fullwidth"] = "alt - f",
          ["window resize"] = "alt - r",
          ["window grow"] = "alt + cmd + ctrl - equal",
          ["window shrink"] = "alt + cmd + ctrl - minus",
          ["window stack"] = "alt - leftbracket",
          ["window unstack"] = "alt - rightbracket",
          ["window manage"] = "alt + cmd + ctrl - escape",
          ["window virtualnum 1"] = "ctrl - 1",
          ["window virtualnum 2"] = "ctrl - 2",
          ["window virtualnum 3"] = "ctrl - 3",
          ["window virtualnum 4"] = "ctrl - 4",
          ["window virtualnum 5"] = "ctrl - 5",
          ["window virtualnum 6"] = "ctrl - 6",
          ["window virtualnum 7"] = "ctrl - 7",
          ["window virtualnum 8"] = "ctrl - 8",
          ["window virtualnum 9"] = "ctrl - 9",
          ["window virtualmovenum 1"] = "ctrl + shift - 1",
          ["window virtualmovenum 2"] = "ctrl + shift - 2",
          ["window virtualmovenum 3"] = "ctrl + shift - 3",
          ["window virtualmovenum 4"] = "ctrl + shift - 4",
          ["window virtualmovenum 5"] = "ctrl + shift - 5",
          ["window virtualmovenum 6"] = "ctrl + shift - 6",
          ["window virtualmovenum 7"] = "ctrl + shift - 7",
          ["window virtualmovenum 8"] = "ctrl + shift - 8",
          ["window virtualmovenum 9"] = "ctrl + shift - 9",
        },

        decorations = {
          active = {
            border = {
              enabled = true,
            },
          },
        },

        padding = {
          top = 6,
          bottom = 6,
          left = 6,
          right = 6,
        },

        swipe = {
          sensitivity = 0.5,
          continuous = false,
          discrete = true,
          gesture = {
            fingers_count = 3,
            direction = "Natural",
            vertical = true,
          },
        },

        windows = {
          all = {
            title = ".*",
            horizontal_padding = 6,
            vertical_padding = 6,
          },
        },
      }

      -- Keep the alternate navigation keys alongside the one-chord-per-command
      -- bindings table above.
      paneru.bind("alt + cmd + ctrl - q", "window focus west")
      paneru.bind("alt + cmd + ctrl - s", "window focus south")
      paneru.bind("alt + cmd + ctrl - w", "window focus north")
      paneru.bind("alt + cmd + ctrl - e", "window focus east")
      paneru.bind("alt + cmd + ctrl - a", "window swap north")
      paneru.bind("alt + cmd + ctrl - d", "window swap south")
    '';
  };

  environment.shells = ["${pkgs.fish}/bin/fish"];

  users.users.${username} = {
    home = "/Users/${username}";
    description = username;
    shell = "${pkgs.fish}/bin/fish";
  };
}
