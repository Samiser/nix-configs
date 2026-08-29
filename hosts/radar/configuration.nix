_: {
  imports = [
    ../../nixos-modules/hetzner-cloud.nix
    ./arr.nix
    ./qbittorrent.nix
    ./seerr.nix
    ./flaresolverr.nix
    ./dashboard.nix
  ];

  host = {
    deploy.enable = true;
    profile.server = true;
  };

  services.storagebox = {
    enable = true;
    user = "radarr";
    group = "radarr";
  };

  networking.hostName = "radar";

  system.stateVersion = "24.11";
}
