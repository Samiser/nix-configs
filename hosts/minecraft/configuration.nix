_: {
  imports = [
    ../../nixos-modules/hetzner-cloud.nix
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
