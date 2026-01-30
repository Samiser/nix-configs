{disko, ...}: {
  imports = [
    ./hardware-configuration.nix
    disko.nixosModules.disko
    ./disko.nix
    ./minecraft-server.nix
    ./backup.nix
  ];

  host = {
    deploy.enable = true;
    profile.server = true;
  };

  services.caddy.enable = true;

  networking.hostName = "minecraft";

  system.stateVersion = "24.11";
}
