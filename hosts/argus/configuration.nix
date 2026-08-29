_: {
  imports = [
    ../../nixos-modules/hetzner-cloud.nix
    ./monitoring.nix
  ];

  host = {
    deploy.enable = true;
    profile.server = true;
  };

  networking.hostName = "argus";

  system.stateVersion = "26.05";
}
