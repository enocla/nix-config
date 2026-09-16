{theme, ...}: let
  c = theme.colors;
  inherit (theme.ui) cornerRadius fontFamily;
in {
  # Keep the reference Waybar/Labwc configuration available even though Noctalia
  # is the default shell and panel for Niri.
  programs.waybar = {
    enable = true;
    settings.bar = {
      height = 24;
      layer = "top";
      spacing = 0;
      position = "bottom";
      modules-left = ["niri/workspaces" "niri/language"];
      modules-center = ["niri/window"];
      modules-right = [
        "tray"
        "wireplumber"
        "network"
        "bluetooth"
        "backlight"
        "clock"
        "battery"
        "battery#bat2"
        "custom/power"
      ];
      "niri/workspaces" = {
        disable-scroll = true;
        all-outputs = true;
        warp-on-scroll = false;
        format = "{icon}";
      };
      tray.spacing = 10;
      "niri/language".format = "{short}";
      clock.tooltip-format = "<big>{:%Y %B}</big>\\n<tt><small>{calendar}</small></tt>";
      backlight = {
        format = "{icon} {percent}%";
        format-icons = ["" "" "" "" "" "" "" "" ""];
      };
      battery = {
        bat = "BAT0";
        states = {
          good = 95;
          warning = 30;
          critical = 15;
        };
        format = "{icon} {capacity}%";
        format-full = "{icon} {capacity}%";
        format-charging = " {capacity}%";
        format-icons = ["" "" "" "" ""];
      };
      "battery#bat2" = {
        bat = "BAT1";
        states = {
          good = 95;
          warning = 30;
          critical = 15;
        };
        format = "{icon} {capacity}%";
        format-full = "{icon} {capacity}%";
        format-charging = " {capacity}%";
        format-plugged = " {capacity}%";
        format-icons = ["" "" "" "" ""];
      };
      bluetooth = {
        format = "";
        format-off = "󰂲";
        on-click = "kitty --hold sh -c 'bluetui'";
      };
      network = {
        format-wifi = " {essid}";
        format-disconnected = "󰖪";
        on-click = "kitty --hold sh -c 'nmtui'";
      };
      wireplumber = {
        format = "{icon} {volume}%";
        format-muted = "󰖁";
        format-icons.default = ["" "" ""];
        on-click = "kitty --hold sh -c 'wiremix'";
      };
      "custom/power" = {
        format = "⏻";
        on-click = "systemctl suspend";
      };
    };
    style = ''
      * {
        font-family: ${fontFamily};
        font-size: 13pt;
        transition-property: background-color;
        transition-duration: .25s;
      }
      window#waybar {
        background-color: ${c.base};
        color: ${c.text};
      }
      button {
        box-shadow: inset 0 -3px transparent;
        border: none;
        border-radius: ${toString cornerRadius};
        margin: 2px 2px;
      }
      #workspaces button {
        padding: 0 5px;
        background-color: transparent;
      }
      #workspaces button.focused, #workspaces button.active {
        background-color: ${c.mauve};
        color: ${c.crust};
      }
      #language, #tray, #bluetooth, #wireplumber, #network, #backlight,
      #clock, #battery, #custom-power {
        margin: 2px 2px;
        padding: 0 10px;
        color: ${c.text};
        border-radius: ${toString cornerRadius};
      }
      #battery, #bluetooth, #wireplumber, #custom-power, #network {
        background-color: ${c.surface1};
      }
      #custom-power { background-color: ${c.mauve}; color: ${c.crust}; }
    '';
  };
}
