{pkgs, ...}: let
  paperwm = pkgs.fetchFromGitHub {
    owner = "mogenson";
    repo = "PaperWM.spoon";
    rev = "3a6d076c5169d693e6271d5af5038036bd591bbd";
    hash = "sha256-H9A7nwt0NkyPqN+iOZ9BU24dkAvvfZxucVSPhNx9WPA=";
  };
  swipe = pkgs.fetchFromGitHub {
    owner = "mogenson";
    repo = "Swipe.spoon";
    rev = "c56520507d98e663ae0e1228e41cac690557d4aa";
    hash = "sha256-G0kuCrG6lz4R+LdAqNWiMXneF09pLI+xKCiagryBb5k=";
  };

in {
  home.file = {
    ".hammerspoon/Spoons/PaperWM.spoon" = {
      source = paperwm;
      recursive = true;
    };
    ".hammerspoon/Spoons/Swipe.spoon" = {
      source = swipe;
      recursive = true;
    };
    ".hammerspoon/init.lua" = {
      source = ./init.lua;
    };
  };
}
