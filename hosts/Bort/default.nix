{
  config,
  determinate,
  helium,
  lib,
  pkgs,
  username,
  ...
}: {
  imports = [
    ../../modules/base
    determinate.nixosModules.default
    helium.nixosModules.default
    ./hardware-configuration.nix
    ./packages.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    hostName = "Bort";
    networkmanager.enable = true;
    firewall.enable = true;
  };

  hardware.bluetooth.enable = true;

  time.timeZone = "Asia/Hong_Kong";
  i18n.defaultLocale = "en_HK.UTF-8";

  nix = {
    settings.experimental-features = ["nix-command" "flakes"];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    optimise.automatic = true;
  };

  nixpkgs.config.allowUnfree = true;

  services = {
    accounts-daemon.enable = true;
    geoclue2.enable = true;
    gvfs.enable = true;
    power-profiles-daemon.enable = true;
    udisks2.enable = true;
    upower.enable = true;
    keyd = {
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
    xserver.enable = false;
    displayManager = {
      defaultSession = "niri";
      sddm.enable = false;
      ly = let
        xsession-wrapper =
          pkgs.runCommand "xsession-wrapper-fixed" {
            src = config.services.displayManager.sessionData.wrapper;
          } ''
            cp --preserve=mode $src $out
            substituteInPlace $out --replace "X-NIXOS-SYSTEMD-AWARE" "X-NIXOS-SYSTEMD-AWARE|niri"
          '';
      in {
        enable = true;
        x11Support = false;
        settings = {
          setup_cmd = "${xsession-wrapper}";
          session_log = ".ly-session.log";
        };
      };
    };
    desktopManager.plasma6.enable = false;
    printing.enable = true;
    openssh.enable = true;
    tailscale.enable = true;
    fstrim.enable = true;
    fwupd.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  fonts = {
    fontDir.enable = true;
    fontconfig = {
      defaultFonts = {
        monospace = [
          "BerkeleyMono Nerd Font"
          "Symbols Nerd Font Mono"
        ];
        sansSerif = ["SF Pro Text"];
        serif = ["SF Pro Text"];
      };
    };
  };

  xdg.menus.enable = true;
  xdg.mime.enable = true;

  environment.sessionVariables.TERMINAL = "kitty";

  security = {
    sudo.enable = false;
    polkit.enable = true;
    rtkit.enable = true;
  };

  zramSwap.enable = true;

  virtualisation.docker.enable = true;

  programs = {
    fish.enable = true;
    helium = {
      enable = true;
      flags = ["--ozone-platform-hint=auto"];
    };
    niri.enable = true;
    gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-qt;
    };
  };

  # keyd 2.6 drops to the keyd group at startup. The upstream NixOS unit only
  # keeps CAP_SYS_NICE, so setgid fails unless CAP_SETGID is added explicitly.
  systemd.services.keyd.serviceConfig.CapabilityBoundingSet = lib.mkAfter ["CAP_SETGID"];

  users.groups.keyd = {};

  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = ["docker" "keyd" "networkmanager" "wheel"];
    shell = pkgs.fish;
  };

  system.stateVersion = "26.05";
}
