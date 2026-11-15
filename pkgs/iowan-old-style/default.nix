{
  lib,
  gnutar,
  gzip,
  openssl,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation {
  pname = "iowan-old-style";
  version = "1.0";
  src = ../../extra/fonts/IowanOldStyle.tar.gz.enc;

  nativeBuildInputs = [gnutar gzip openssl];
  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/share/fonts/truetype" "$TMPDIR/iowan-old-style"
    # The password is embedded in the derivation, so this provides obfuscation
    # only; it is not confidential from users who can read the recipe or store.
    openssl enc -d -aes-256-cbc -pbkdf2 -iter 200000 \
      -pass pass:4506c9b014f1da6bbe00170dfcf226097211cfdeb6799ea41bfc968e6e5609e9 \
      -in "$src" | tar -xzf - -C "$TMPDIR/iowan-old-style"
    install -Dm644 "$TMPDIR/iowan-old-style/IowanOldStyle/Iowan Old Style.ttc" \
      "$out/share/fonts/truetype/Iowan Old Style.ttc"
    runHook postInstall
  '';

  meta = {
    description = "Iowan Old Style font family";
    license = lib.licenses.unfree;
    platforms = lib.platforms.all;
  };
}
