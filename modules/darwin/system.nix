{username, ...}: {
  ids.gids.nixbld = 30000;

  system = {
    primaryUser = username;
    stateVersion = 6;
  };
}
