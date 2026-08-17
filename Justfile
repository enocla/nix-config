host := `hostname -s`

deploy:
    nix build .#darwinConfigurations.{{host}}.system
    sudo ./result/activate

build:
    nix build .#darwinConfigurations.{{host}}.system

update:
    nix flake update
    nix build .#darwinConfigurations.{{host}}.system

clean:
    nix-collect-garbage --delete-older-than 7d

fmt:
    nix fmt .
    stylua . --sort-requires --indent-type spaces --indent-width 4
