{ disko, ... }: {
  imports = [
    ./hardware-configuration.nix
    disko.nixosModules.disko
    ./disko.nix
    ./tailscale.nix
    ./radarr.nix
    ./sonarr.nix
    ./prowlarr.nix
    ./storagebox.nix
    ./qbittorrent.nix
    ./seerr.nix
    ./flaresolverr.nix
    ./dashboard.nix
  ];

  host = {
    deploy.enable = true;
    profile.server = true;
  };

  networking.hostName = "radar";

  system.stateVersion = "24.11";
}
