{nixcord, ...}: {
  imports = [nixcord.homeModules.nixcord];

  programs.nixcord = {
    enable = true;
    discord.equicord.enable = true;
  };
}
