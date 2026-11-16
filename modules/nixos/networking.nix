{
  config,
  inputs,
  ...
}: {
  imports = [inputs.tether.nixosModules.default];

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

  # Upstream ships tetherd as a user unit but leaves it disabled; start it on login.
  systemd.packages = [config.programs.tether.package];
  systemd.user.services.tetherd.wantedBy = ["default.target"];
}
