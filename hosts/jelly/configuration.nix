{disko, ...}: {
  imports = [
    ./hardware-configuration.nix
    disko.nixosModules.disko
    ./disko.nix
    ./jellyfin.nix
    ./storagebox.nix
  ];

  host = {
    deploy.enable = true;
    profile.server = true;
  };

  services.caddy.enable = true;

  networking.hostName = "jelly";

  system.stateVersion = "24.11";
}
