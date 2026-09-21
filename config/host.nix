let
  common = {
    configRepoName = "nix-config";
    gpgKey = "6AB7F7CC83CEC7A6";
    gitUserName = "enocla";
    gitUserEmail = "tnixxc@gmail.com";
    homeStateVersion = "25.11";
  };
in
  builtins.mapAttrs (hostname: host: let
    homeDirectory =
      if builtins.match ".*-darwin" host.system != null
      then "/Users/${host.username}"
      else "/home/${host.username}";
  in
    common
    // host
    // {
      inherit hostname homeDirectory;
      # Live application settings intentionally follow this checkout.
      # Override per host if the repository is moved.
      checkoutPath = host.checkoutPath or "${homeDirectory}/${common.configRepoName}";
    }) {
    Bort = {
      username = "enocla";
      system = "x86_64-linux";
      systemStateVersion = "26.05";
    };
    Diamond = {
      username = "tnixc";
      system = "aarch64-darwin";
      systemStateVersion = 6;
    };
  }
