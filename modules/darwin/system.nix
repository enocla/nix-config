{host, ...}: {
  ids.gids.nixbld = 30000;

  system = {
    primaryUser = host.username;
    stateVersion = host.systemStateVersion;
  };
}
