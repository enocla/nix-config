{
  security = {
    sudo.enable = false;
    polkit = {
      enable = true;
      # Keep run0's temporary polkit authorization from expiring. polkitd
      # parses this as a guint32, so G_MAXUINT is effectively "never".
      settings.Polkitd.ExpirationSeconds = 4294967295;
    };
    rtkit.enable = true;
  };
}
