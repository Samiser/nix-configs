{disko, ...}: {
  imports = [
    ./hardware-configuration.nix
    disko.nixosModules.disko
    ./disko.nix
    ../../nixos-modules/modules
    ../../nixos-modules/profiles/base.nix
    ../../nixos-modules/profiles/server.nix
    ../../shared-modules/garnix.nix
    ./minecraft-server.nix
    ./backup.nix
  ];

  services.caddy.enable = true;

  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;

  networking.hostName = "minecraft";

  system.stateVersion = "24.11";
}
