{disko, ...}: {
  imports = [
    ./hardware-configuration.nix
    disko.nixosModules.disko
    ./disko.nix
    ./minecraft-server.nix
    ./backup.nix
  ];

  host.profile.server = true;

  services.caddy.enable = true;

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  networking.hostName = "minecraft";

  system.stateVersion = "24.11";
}
