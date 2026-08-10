{username, ...}:
#############################################################
#
#  Host & Users configuration
#
#############################################################
{
  environment.shells = ["/opt/homebrew/bin/fish"];

  users.users."${username}" = {
    home = "/Users/${username}";
    description = username;
    shell = "/opt/homebrew/bin/fish";
  };
}
