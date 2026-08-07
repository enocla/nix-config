{...}: {
  nixpkgs.overlays = [
    # fish's test suite is flaky on darwin
    (final: prev: {
      fish = prev.fish.overrideAttrs (oldAttrs: {
        doCheck = false;
      });
    })
  ];
}
