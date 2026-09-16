{
  config,
  pkgs,
  ...
}: {
  services = {
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
  };
}
