{config, ...}: {
  sops = {
    gnupg.home = "${config.home.homeDirectory}/.gnupg";
    defaultSopsFile = ../../../secrets/ssh.yaml;
    secrets."ssh-config" = {
      key = "ssh-config";
      path = "${config.home.homeDirectory}/.ssh/config";
      mode = "0600";
    };
  };
}
