{
  lib,
  pkgs,
  ...
}: let
  # Autologin through ly never hands PAM a password, so the login keyring starts
  # locked. User services in default.target (e.g. T3 Code's server) can ask for
  # a secret before niri exists; gnome-keyring's unlock prompt then fails with
  # "cannot open display", and every Chromium/Electron app hangs waiting for
  # its cookie key, so no page loads. Once the session is up, raise the unlock
  # prompt where it can actually be seen.
  python = pkgs.python3.withPackages (ps: [ps.pygobject3]);
  keyringUnlock = pkgs.writeShellApplication {
    name = "keyring-unlock-prompt";
    text = ''
      export GI_TYPELIB_PATH=${lib.makeSearchPath "lib/girepository-1.0" [pkgs.glib.out]}
      exec ${lib.getExe python} ${./keyring-unlock-prompt.py}
    '';
  };
in {
  # Seahorse manages the login keyring (e.g. giving it an empty password).
  home.packages = [pkgs.seahorse];

  systemd.user.services.keyring-unlock-prompt = {
    Unit = {
      Description = "Prompt to unlock the login keyring once the graphical session exists";
      PartOf = ["graphical-session.target"];
      After = ["graphical-session.target"];
    };
    Service = {
      Type = "oneshot";
      ExecStart = lib.getExe keyringUnlock;
    };
    Install.WantedBy = ["graphical-session.target"];
  };
}
