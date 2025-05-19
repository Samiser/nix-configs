# nix configs

my nixos/nix-darwin stuff :)

## folder structure

- `home-manager/`
  - home-manager modules
- `nixos-modules/`
  - nixos modules
- `darwin-modules/`
  - nix-darwin modules
- `hosts/`
  - host-specific configuration
- `lib/`
  - nix helpers
- `secrets/`
  - agenix secrets

## systems.nix

the flake outputs are determined by the directory structure and filenames in the
`hosts/` directory, similar to
[blueprint](https://github.com/numtide/blueprint).

each directory contains a host configuration, and the filename of the main
configuration file determines which type of system to build:

- `configuration.nix`: nixos (x86_64-linux)
- `darwin-configuration.nix`: darwin (aarch64-darwin)

i'm currently assuming that nixos hosts will be x86 and darwin arm, so if i ever
want to build eg. arm nixos i'll have to do some rewriting.
