{
  lib,
  pkgs,
  username,
  ...
}: let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  homeDirectory =
    if isDarwin
    then "/Users/${username}"
    else "/home/${username}";
  shell =
    if isDarwin
    then "${pkgs.fish}/bin/fish"
    else pkgs.fish;
in {
  environment.shells = [shell];

  users.users.${username} = {
    home = lib.mkDefault homeDirectory;
    description = username;
    inherit shell;
  };
}
