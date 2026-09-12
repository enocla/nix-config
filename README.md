# <img width="26.75" height="23.2" alt="image" src="https://github.com/user-attachments/assets/2d661810-b55c-4b5b-8087-4ecc8d51a178" /> nix-config

Nix configurations for:

- `Diamond`: Apple silicon macOS, managed with nix-darwin and Malt
- `Bort`: x86_64 Linux, managed with NixOS and nixpkgs

## Organization

The configuration is layered so shared behavior has one owner:

- `config/host.nix` contains host metadata passed to every system and Home Manager module.
- `modules/base` contains cross-platform system defaults, shared packages, fonts, user setup, and package policy.
- `modules/darwin` contains macOS-only nix-darwin settings such as Malt, preferences, and Touch ID.
- `hosts/Diamond` and `hosts/Bort` contain machine and desktop policy that should not be shared, such as Paneru, Niri, keyd, services, and hardware.
- `home` contains the shared Home Manager profile, with platform-specific imports kept next to the affected program.
- `flake.nix` provides one Home Manager constructor and one system constructor per platform, avoiding duplicated wiring.

## Checks and builds

```sh
nix fmt
nix build .#darwinConfigurations.Diamond.system
nix build .#nixosConfigurations.Bort.config.system.build.toplevel
```

For local deployment, use the repository's `Justfile` targets (`just build`, `just deploy`, and `just fmt`).

<img width="2559" height="1079" alt="image" src="https://github.com/user-attachments/assets/872f4bdf-4b02-4270-a47a-5b894395cc9a" />
