host := `hostname -s`

deploy:
    darwin-rebuild switch --flake .#{{host}}

build:
    darwin-rebuild build --flake .#{{host}}

update:
    nix flake update
    darwin-rebuild build --flake .#{{host}}

clean:
    nix-collect-garbage --delete-older-than 7d

fmt:
    nix fmt .
    stylua . --sort-requires --indent-type spaces --indent-width 4
