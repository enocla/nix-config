{
  lib,
  fetchzip,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation {
  pname = "dcd";
  version = "1.1.0";

  src = fetchzip {
    url = "https://github.com/boyter/dcd/releases/download/v1.1.0/dcd-1.0.0-x86_64-unknown-linux.zip";
    hash = "sha256-f64Ji2m7o/HLe35L83DnlSzeY/g2Ez8ZBIzHmkO0v9I=";
  };

  installPhase = ''
    runHook preInstall
    install -Dm755 dcd "$out/bin/dcd"
    runHook postInstall
  '';

  meta = {
    description = "Duplicate code detector with fuzzy matching";
    homepage = "https://github.com/boyter/dcd";
    license = lib.licenses.agpl3Only;
    platforms = ["x86_64-linux"];
    mainProgram = "dcd";
  };
}
