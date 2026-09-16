{lib, ...}: {
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = ["*"];
      settings = {
        global.overload_tap_timeout = 250;
        main = {
          capslock = "overload(hyper, tab)";
          # The existing Alt/Meta swap makes the physical Command key emit Meta.
          # Keep that Super behavior for ordinary shortcuts while giving Cmd its
          # own layer so only the macOS editing shortcuts are translated.
          leftalt = "layer(cmd)";
          leftmeta = "layer(alt)";
          rightalt = "layer(cmd)";
          rightmeta = "layer(altgr)";
        };
        shift = {
          esc = "S-`";
        };
        "cmd:M" = {
          # Translate standard macOS application shortcuts to their Linux
          # Ctrl equivalents. Unlisted chords retain Meta/Super, so Cmd+Space,
          # Cmd+Q, and the Niri shortcuts continue to work as before.
          "0" = "C-0";
          "1" = "C-1";
          "2" = "C-2";
          "3" = "C-3";
          "4" = "C-4";
          "5" = "C-5";
          "6" = "C-6";
          "7" = "C-7";
          "8" = "C-8";
          "9" = "C-9";
          a = "C-a";
          c = "C-c";
          equal = "C-equal";
          f = "C-f";
          g = "C-g";
          l = "C-l";
          minus = "C-minus";
          n = "C-n";
          o = "C-o";
          p = "C-p";
          r = "C-r";
          s = "C-s";
          t = "C-t";
          v = "C-v";
          w = "C-w";
          x = "C-x";
          z = "C-z";
        };
        "hyper:C-M-A" = {};
      };
    };
  };

  # keyd 2.6 drops to the keyd group at startup. The upstream NixOS unit only
  # keeps CAP_SYS_NICE, so setgid fails unless CAP_SETGID is added explicitly.
  systemd.services.keyd.serviceConfig.CapabilityBoundingSet = lib.mkAfter ["CAP_SETGID"];

  users.groups.keyd = {};
}
