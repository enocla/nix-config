{
  host,
  pkgs,
  ...
}: {
  programs.jujutsu = {
    enable = true;
    package = pkgs.jujutsu;
    settings = {
      user = {
        name = host.gitUserName;
        email = host.gitUserEmail;
      };
      signing = {
        backend = "gpg";
        sign-all = true;
        key = host.gpgKey;
      };

      fsmonitor.backend = "watchman";
      snapshot.max-new-file-size = "10MiB";
    };
  };

  # Jujutsu's fsmonitor backend invokes Watchman for repository changes.
  home.packages = [pkgs.watchman];
}
