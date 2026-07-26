{rust-overlay, ...}: {
  nixpkgs.overlays = [
    rust-overlay.overlays.default
    # fish
    (final: prev: {
      fish = prev.fish.overrideAttrs (oldAttrs: {
        doCheck = false;
      });
    })
    # fmt tests fail to compile with newer clang
    (final: prev: {
      fmt_9 = prev.fmt_9.overrideAttrs (oldAttrs: {
        cmakeFlags = (oldAttrs.cmakeFlags or []) ++ ["-DFMT_TEST=OFF"];
        doCheck = false;
      });
    })
    # micropython's test suite currently fails on Darwin despite compiling successfully
    (final: prev: {
      micropython = prev.micropython.overrideAttrs {
        doCheck = false;
      };
    })
  ];
}
