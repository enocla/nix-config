{
  lib,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation {
  pname = "macos-tahoe-cursor";
  version = "1.4";

  # Vendored under extra/cursors rather than fetched, so the theme is pinned
  # and available offline. ReadMe.txt in the source carries the creator's
  # attribution and license; the files are installed verbatim.
  src = ../../extra/cursors/MacOS-Tahoe-Cursor;

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/share/icons/MacOS-Tahoe-Cursor"
    cp -r "$src"/. "$out/share/icons/MacOS-Tahoe-Cursor/"
    runHook postInstall
  '';

  # The cursor files are Xcursor binaries, so they work as-is with GTK, Qt and
  # X11 without conversion from the macOS originals.
  meta = {
    description = "macOS Tahoe cursor theme";
    longDescription = ''
      The macOS Tahoe cursor theme by Moyash, packaged for Linux use. The
      cursors/ directory holds Xcursor binaries under both the standard X11
      cursor names and the hashed macOS names, installed verbatim into the
      conventional share/icons layout so that icon and cursor lookups find it.
    '';
    license = lib.licenses.cc-by-nc-nd-40;
    # Not the bare "linux" string: meta.platforms is matched by exact system
    # string, so the concrete list is required.
    platforms = lib.platforms.linux;
  };
}
