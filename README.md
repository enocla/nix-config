# <img width="26.75" height="23.2" alt="image" src="https://github.com/user-attachments/assets/2d661810-b55c-4b5b-8087-4ecc8d51a178" /> nix-config





Nix configurations for:

- `Diamond`: Apple silicon macOS, managed with nix-darwin and Malt
- `Bort`: x86_64 Linux, managed with NixOS and nixpkgs

Host modules live in `hosts/`, shared system modules in `modules/`, and shared Home Manager configuration in `home/`.

<img width="1709" height="1112" alt="image" src="https://github.com/user-attachments/assets/7aeb27cf-90dd-4625-beb5-3109a5936c39" />


---

- [Evergarden theme](https://evergarden.moe/)
- Lots taken from [SapphoSys/dotfiles](https://github.com/SapphoSys/dotfiles)


## Secrets

The SSH configuration is stored encrypted at `secrets/ssh.yaml` with SOPS and the existing OpenPGP key `6AB7F7CC83CEC7A6` from `~/.gnupg`. The Home Manager sops-nix module uses each host's `~/.gnupg` keyring to decrypt it; private key material is never stored in this repository or the Nix store.

The same private GPG key must be available in both users' keyrings before applying the configuration. To securely copy the key to Bort when needed, use an authenticated SSH connection and import the stream directly:

```sh
nix shell nixpkgs#gnupg --command sh -c \
  'gpg --export-secret-keys --armor 6AB7F7CC83CEC7A6 | ssh Bort gpg --import'
```

After that, applying either host configuration decrypts the secret at activation and places it at `~/.ssh/config` with mode `0600`. Keep the GPG private key protected and never commit it or copy it into the Nix store.
