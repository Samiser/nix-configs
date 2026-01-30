# nix configs

my nixos/nix-darwin stuff :)

## folder structure

- `hosts/` - host-specific configuration
- `nixos-modules/` - nixos modules and profiles
- `darwin-modules/` - nix-darwin modules
- `home-manager/` - home-manager modules
- `shared-modules/` - modules shared between nixos and darwin
- `lib/` - flake output generation
- `secrets/` - agenix secrets

## hosts

flake outputs are determined by the `hosts/` directory structure. each
subdirectory is a host, and the config filename determines the system type:

- `configuration.nix` → nixos
- `darwin-configuration.nix` → darwin

## deployment

hosts with `host.deploy.enable = true` can be deployed via deploy-rs:

```bash
nix develop
deploy .#hostname
```
