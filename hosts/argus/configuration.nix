{disko, ...}: {
  imports = [
    ./hardware-configuration.nix
    disko.nixosModules.disko
    ../../nixos-modules/disko.nix
  ];

  host = {
    deploy.enable = true;
    profile.server = true;
  };

  networking.hostName = "argus";

  system.stateVersion = "26.05";
}
