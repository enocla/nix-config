{
  lib,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation {
  pname = "inter-theme";
  version = "4.1";
  src = ../../extra/fonts/InterTheme.tar.gz;

  installPhase = ''
    runHook preInstall
    install -Dm644 *.ttc *.ttf -t "$out/share/fonts/truetype"
    install -Dm644 LICENSE.txt README.md -t "$out/share/doc/inter-theme"
    runHook postInstall
  '';

  meta = {
    description = "Inter with ss01 and ss02 baked in, retaining an unslashed zero";
    homepage = "https://rsms.me/inter/";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
}
