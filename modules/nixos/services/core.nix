{
  services = {
    accounts-daemon.enable = true;
    geoclue2.enable = true;
    gvfs.enable = true;
    power-profiles-daemon.enable = true;
    udisks2.enable = true;
    upower.enable = true;
    printing.enable = true;
    fstrim.enable = true;
    fwupd.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
