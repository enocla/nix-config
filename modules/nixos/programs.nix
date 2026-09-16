{pkgs, ...}: {
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
}
