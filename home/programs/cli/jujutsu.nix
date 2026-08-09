{
  externalPackage,
  gpgKey,
  ...
}: {
  programs.jujutsu = {
    enable = true;
    package = externalPackage "jj" {};
    settings = {
      user = {
        name = "Tnixc";
        email = "tnixxc@gmail.com";
      };
      signing = {
        backend = "gpg";
        sign-all = true;
        key = gpgKey;
      };

      fsmonitor.backend = "watchman";
      snapshot.max-new-file-size = "10MiB";
    };
  };
}
