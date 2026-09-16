{
  config,
  configRepoName,
  dms,
  lib,
  noctalia,
  theme,
  ...
}: let
  c = theme.colors;
  configDir = "${config.home.homeDirectory}/${configRepoName}/home/config";
  mkLink = config.lib.file.mkOutOfStoreSymlink;
in {
  # Keep DMS available as an input/module, but use Noctalia for this Linux host.
  imports = [
    dms.homeModules.dank-material-shell
    noctalia.homeModules.default
  ];

  programs.dank-material-shell = {
    enable = lib.mkForce false;
    systemd.enable = false;
  };

  services.polkit-gnome.enable = true;
  systemd.user.services.polkit-gnome = {
    Service = {
      Restart = "on-failure";
      RestartSec = 1;
    };
    Unit = {
      StartLimitIntervalSec = 30;
      StartLimitBurst = 10;
    };
  };

  programs.noctalia = {
    enable = true;
    # This file intentionally lives outside the Nix store so Noctalia can edit it.
    # Build-time validation cannot follow that host checkout from the sandbox.
    checkConfig = false;
    settings = mkLink "${configDir}/noctalia/config.toml";
    customPalettes."nix-config" = {
      dark = {
        mPrimary = c.mauve;
        mOnPrimary = c.crust;
        mSecondary = c.teal;
        mOnSecondary = c.crust;
        mTertiary = c.pink;
        mOnTertiary = c.crust;
        mError = c.red;
        mOnError = c.crust;
        mSurface = c.base;
        mOnSurface = c.text;
        mSurfaceVariant = c.surface1;
        mOnSurfaceVariant = c.subtext1;
        mOutline = c.overlay1;
        mShadow = c.crust;
        mHover = c.pink;
        mOnHover = c.crust;
        terminal = {
          normal = {
            black = c.crust;
            red = c.red;
            green = c.green;
            yellow = c.yellow;
            blue = c.blue;
            magenta = c.mauve;
            cyan = c.sky;
            white = c.text;
          };
          bright = {
            black = c.overlay0;
            red = c.red;
            green = c.green;
            yellow = c.yellow;
            blue = c.blue;
            magenta = c.pink;
            cyan = c.sapphire;
            white = c.subtext1;
          };
          foreground = c.text;
          background = c.base;
          cursor = c.rosewater;
          cursorText = c.crust;
          selectionFg = c.text;
          selectionBg = c.surface1;
        };
      };
    };
  };
}
