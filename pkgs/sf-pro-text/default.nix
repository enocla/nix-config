{
  lib,
  gnutar,
  gzip,
  openssl,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation {
  pname = "sf-pro-text";
  version = "1";
  src = ../../extra/fonts/SFProText.tar.gz.enc;

  nativeBuildInputs = [gnutar gzip openssl];
  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/share/fonts/opentype" "$TMPDIR/sf-pro-text"
    # The password is embedded in the derivation, so this provides obfuscation
    # only; it is not confidential from users who can read the recipe or store.
    openssl enc -d -aes-256-cbc -pbkdf2 -iter 200000 \
      -pass pass:4506c9b014f1da6bbe00170dfcf226097211cfdeb6799ea41bfc968e6e5609e9 \
      -in "$src" | tar -xzf - -C "$TMPDIR/sf-pro-text"
    install -Dm644 "$TMPDIR/sf-pro-text/SFProText/"*.otf \
      -t "$out/share/fonts/opentype"
    runHook postInstall
  '';

  meta = {
    description = "Apple SF Pro Text font";
    license = lib.licenses.unfree;
    platforms = lib.platforms.all;
  };
}
