{...}: {
  # App icons (darwin-custom-icons)
  environment.customIcons = {
    enable = true;
    icons = [
      {
        path = "/Applications/Cloudflare WARP.app";
        icon = ./cf_warp.icns;
      }
      {
        path = "/Applications/Ableton Live 12 Suite.app";
        icon = ./Ableton.icns;
      }
      {
        path = "/System/Volumes/Data/Applications/Equibop.app";
        icon = ./Discord.icns;
      }
    ];
  };
}
