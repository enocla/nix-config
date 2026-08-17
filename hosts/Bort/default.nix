{
  determinate,
  helium,
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
    power-profiles-daemon.enable = true;
    keyd = {
      enable = true;
      keyboards.default = {
        ids = ["*"];
        settings = {
          global.overload_tap_timeout = 250;
          main.capslock = "overload(hyper, tab)";
          "hyper:C-M-A-S" = {};
        };
      };
    };
    xserver = {
      enable = true;
      xkb.layout = "us";
    };
    displayManager = {
      defaultSession = "niri";
      sddm.enable = true;
    };
    desktopManager.plasma6.enable = true;
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
          "SF Pro Text"
          "Symbols Nerd Font Mono"
        ];
        sansSerif = ["BerkeleyMono Nerd Font" "SF Pro Text"];
        serif = ["BerkeleyMono Nerd Font" "SF Pro Text"];
      };
      localConf = ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
        <fontconfig>
          <match target="pattern">
            <test name="family" qual="first">
              <string>BerkeleyMono Nerd Font</string>
            </test>
            <edit name="family" mode="append" binding="strong">
              <string>SF Pro Text</string>
              <string>Symbols Nerd Font Mono</string>
            </edit>
          </match>
        </fontconfig>
      '';
    };
  };

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

  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = ["docker" "networkmanager" "wheel"];
    shell = pkgs.fish;
  };

  system.stateVersion = "26.05";
}
