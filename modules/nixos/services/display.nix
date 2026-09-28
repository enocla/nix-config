{
  config,
  host,
  pkgs,
  ...
}: {
  services = {
    xserver.enable = false;
    displayManager = {
      defaultSession = "niri";
      # Boot straight into the desktop. The root filesystem is unencrypted, so
      # this intentionally gives up the login prompt as a physical-access
      # barrier: anyone who can power on the machine gets this session.
      autoLogin = {
        enable = true;
        user = host.username;
      };
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
