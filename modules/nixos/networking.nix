{
  networking = {
    networkmanager.enable = true;
    firewall.enable = true;
  };

  programs.tether = {
    enable = true;
    wifi = {
      enable = true;
      openFirewall = true;
    };
    bluetooth = {
      enable = true;
      adapters = ["hci0"];
    };
  };
}
