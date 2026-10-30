{pkgs, ...}: let
  # Sushi is Nautilus's Quick Look: Space previews the selected file. Its
  # wrapper pins GDK_PIXBUF_MODULE_FILE to librsvg's loaders only, so WebP,
  # HEIF and JPEG XL images fall back to a generic icon. Give it the same
  # loader set nixpkgs gives Eye of GNOME.
  sushi = pkgs.sushi.overrideAttrs (old: {
    # Runs before gappsWrapperArgsHook, which records this value in the wrapper.
    postInstall =
      (old.postInstall or "")
      + ''
        export GDK_PIXBUF_MODULE_FILE="${
          pkgs.gnome._gdkPixbufCacheBuilder_DO_NOT_USE {
            extraLoaders = with pkgs; [
              libjxl
              librsvg
              webp-pixbuf-loader
              libheif.lib
            ];
          }
        }"
      '';
  });
in {
  environment.systemPackages = [sushi];

  services = {
    accounts-daemon.enable = true;
    # Nautilus starts Sushi over D-Bus as org.gnome.NautilusPreviewer.
    dbus.packages = [sushi];
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
