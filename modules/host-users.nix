{
  pkgs,
  username,
  ...
}:
#############################################################
#
#  Host & Users configuration
#
#############################################################
{
  environment.shells = ["${pkgs.fish}/bin/fish"];

  users.users."${username}" = {
    home = "/Users/${username}";
    description = username;
    shell = "${pkgs.fish}/bin/fish";
  };
}
