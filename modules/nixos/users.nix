{username, ...}: {
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = ["docker" "keyd" "networkmanager" "wheel"];
  };
}
