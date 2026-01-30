{lib, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../../nixos-modules/config.nix
    ../../nixos-modules/users.nix
    ../../nixos-modules/server.nix
    ../../shared-modules/garnix.nix
    ../../nixos-modules/pkgs.nix
    ../../nixos-modules/agenix.nix
    ../../nixos-modules/services/tailscale.nix
    ./caddy.nix
    ./ssc.nix
    ./gpa-calc.nix
    ./miniflux.nix
  ];

  systemd = {
    network.enable = true;

    network.networks."10-wan" = {
      matchConfig.Name = "eth0";
      networkConfig.DHCP = "yes";
    };

    services.systemd-networkd-wait-online.enable = lib.mkForce false;
  };

  networking = {
    useNetworkd = true;
    hostName = "nix-lab";
    domain = "";
  };

  # Custom host config
  hostConfig = {
    gui.enable = false;
  };

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "24.05";
}
