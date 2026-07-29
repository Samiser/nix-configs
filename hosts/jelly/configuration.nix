{disko, ...}: {
  imports = [
    ./hardware-configuration.nix
    disko.nixosModules.disko
    ../../nixos-modules/disko.nix
    ./jellyfin.nix
  ];

  host = {
    deploy.enable = true;
    profile.server = true;
  };

  services.caddy.enable = true;

  services.storagebox = {
    enable = true;
    user = "jellyfin";
    group = "jellyfin";
    fileMode = "0640";
    dirMode = "0750";
    extraOptions = [
      "hard"
      "actimeo=60"
      "cache=loose"
      "rsize=4194304"
      "wsize=4194304"
    ];
  };

  networking.hostName = "jelly";

  system.stateVersion = "24.11";
}
