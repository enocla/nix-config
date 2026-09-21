{
  lib,
  fetchzip,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation {
  pname = "prism";
  version = "1.4.1";

  src = fetchzip {
    url = "https://github.com/DaltonSW/prism/releases/download/v1.4.1/prism_Linux_x86_64.tar.gz";
    hash = "sha256-wM+vNtSP+6h3+Q7OwExYTkQGgYCkkCrO19a/lrieYKc=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall
    install -Dm755 prism "$out/bin/prism"
    runHook postInstall
  '';

  meta = {
    description = "Beautiful output for Go test results";
    homepage = "https://github.com/DaltonSW/prism";
    license = lib.licenses.mit;
    platforms = ["x86_64-linux"];
    mainProgram = "prism";
  };
}
