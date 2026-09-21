{
  lib,
  pkgs,
  host,
  ...
}: let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  shell =
    if isDarwin
    then "${pkgs.fish}/bin/fish"
    else pkgs.fish;
in {
  environment.shells = [shell];

  users.users.${host.username} = {
    home = lib.mkDefault host.homeDirectory;
    description = host.username;
    inherit shell;
  };
}
