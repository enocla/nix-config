{
  config,
  pkgs,
  ...
}: let
  cacheHome = config.xdg.cacheHome;
  rustcWrapper = pkgs.writeShellScript "rustc-sccache" ''
    # Cargo already passes incremental settings as rustc flags. sccache 0.19
    # rejects CARGO_INCREMENTAL=1 before it can pass incremental crates through.
    unset CARGO_INCREMENTAL
    exec ${pkgs.sccache}/bin/sccache "$@"
  '';
in {
  home.packages = [pkgs.sccache];

  # Apply the limit even when `sccache --show-stats` starts the server outside Cargo.
  home.file.${
    if pkgs.stdenv.hostPlatform.isDarwin
    then "Library/Application Support/Mozilla.sccache/config"
    else "${config.xdg.configHome}/sccache/config"
  }.source = (pkgs.formats.toml {}).generate "sccache-config" {
    cache.disk = {
      dir = "${cacheHome}/sccache";
      size = 30 * 1024 * 1024 * 1024;
    };
  };

  # Cargo reads this inside `nix develop` as well as in ordinary shells.
  # Keep workspace incremental compilation; sccache handles reusable dependencies.
  home.file.".cargo/config.toml".source = (pkgs.formats.toml {}).generate "cargo-config.toml" {
    build = {
      rustc-wrapper = "${rustcWrapper}";
      target-dir = "${cacheHome}/cargo/target";
    };
    env = {
      SCCACHE_DIR = "${cacheHome}/sccache";
      SCCACHE_CACHE_SIZE = "30G";
    };
  };
}
