{disko, ...}: {
  imports = [
    ./hardware-configuration.nix
    disko.nixosModules.disko
    ./disko.nix
    ../../nixos-modules/config.nix
    ../../nixos-modules/users.nix
    ../../nixos-modules/agenix.nix
    ../../nixos-modules/server.nix
    ../../shared-modules/garnix.nix
    ./minecraft-server.nix
    ./caddy.nix
    ./backup.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;

  networking.hostName = "minecraft";

  system.stateVersion = "24.11";
}
