let
  common = {
    configRepoName = "nix-config";
    gpgKey = "6AB7F7CC83CEC7A6";
    gitUserName = "enocla";
    gitUserEmail = "tnixxc@gmail.com";
  };
in {
  Diamond =
    common
    // {
      hostname = "Diamond";
      username = "tnixc";
      system = "aarch64-darwin";
    };

  Bort =
    common
    // {
      hostname = "Bort";
      username = "enocla";
      system = "x86_64-linux";
    };
}
