{host, ...}: {
  users.users.${host.username} = {
    isNormalUser = true;
    extraGroups = ["docker" "keyd" "networkmanager" "wheel"];
  };
}
