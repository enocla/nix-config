{
  time.timeZone = "America/Toronto";
  i18n.defaultLocale = "en_HK.UTF-8";

  xdg.menus.enable = true;
  xdg.mime.enable = true;

  environment.sessionVariables = {
    TERMINAL = "kitty";
    # Chromium- and Electron-based packages in nixpkgs add their own native
    # Wayland flags when this is set (and a Wayland session is running).
    NIXOS_OZONE_WL = "1";
  };
}
