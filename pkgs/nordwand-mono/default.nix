{
  lib,
  fetchzip,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "nordwand-mono";
  version = "1.4.0";

  src = fetchzip {
    url = "https://github.com/tywr/Nordwand-Mono/releases/download/${finalAttrs.version}/NordwandMono-OTF.zip";
    # The release archive has no top-level directory.
    stripRoot = false;
    hash = "sha256-H6jSgWK2MinZmDCC5rbpP5KSSu1tW5tZg6hT+yHUqGs=";
  };

  installPhase = ''
    runHook preInstall
    install -Dm644 *.otf -t "$out/share/fonts/opentype"
    runHook postInstall
  '';

  meta = {
    description = "Compact monospace neo-grotesque font";
    homepage = "https://github.com/tywr/Nordwand-Mono";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
})
