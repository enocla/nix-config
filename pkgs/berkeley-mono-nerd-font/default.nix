{
  lib,
  gnutar,
  gzip,
  openssl,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation {
  pname = "berkeley-mono-nerd-font";
  version = "1";
  src = ../../extra/fonts/BerkeleyMonoNerdFont.tar.gz.enc;

  nativeBuildInputs = [gnutar gzip openssl];
  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/share/fonts/truetype" "$TMPDIR/berkeley-mono"
    # The password is embedded in the derivation, so this provides obfuscation
    # only; it is not confidential from users who can read the recipe or store.
    openssl enc -d -aes-256-cbc -pbkdf2 -iter 200000 \
      -pass pass:4506c9b014f1da6bbe00170dfcf226097211cfdeb6799ea41bfc968e6e5609e9 \
      -in "$src" | tar -xzf - -C "$TMPDIR/berkeley-mono"
    install -Dm644 "$TMPDIR/berkeley-mono/BerkeleyMonoNerdFont/"*.ttf \
      -t "$out/share/fonts/truetype"
    runHook postInstall
  '';

  meta = {
    description = "Berkeley Mono Nerd Font";
    license = lib.licenses.unfree;
    platforms = lib.platforms.all;
  };
}
