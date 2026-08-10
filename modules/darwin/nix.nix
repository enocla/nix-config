{...}: {
  nix = {
    enable = false;
    # Nix gc works slightly differently on darwin, so we need to adjust the
    # interval such that it works properly here.
    # gc = {
    #   automatic = true;
    #   interval = {
    #     Hour = 3;
    #     Minute = 15;
    #   };
    #   options = "--delete-older-than 7d";
    # };

    # # We add more platforms here because of the limited number of darwin
    # # maintainers that exist, thus meaning less working packages for darwin.
    # settings.extra-platforms = [
    #   "aarch64-darwin"
    #   "x86_64-darwin"
    # ];
  };
}
