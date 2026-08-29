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

## option namespaces

custom options live under one root per layer:

- `host.*` (nixos) - host-level toggles set in `configuration.nix`:
  - `host.profile.*` system profiles
  - `host.deploy.enable` whether its a deploy-rs target
- `services.*` (nixos/darwin) - custom system services (avoiding upstream
  collision)
- `sam.*` (home-manager only) - per-program user config

## deployment

hosts with `host.deploy.enable = true` can be deployed via deploy-rs:

```bash
nix develop
deploy .#hostname
```
