{...}: {
  imports = [
    ./hardware-configuration.nix
    ../../nixos-modules/modules
    ../../nixos-modules/profiles/base.nix
    ../../nixos-modules/profiles/server.nix
    ../../shared-modules/garnix.nix
  ];

  services.tailscale-local.enable = true;
  services.caddy.enable = true;

  services.ssc = {
    enable = true;
    domain = "samiser.xyz";
  };

  services.gpa-calc = {
    enable = true;
    domain = "gpa-calc.samiser.xyz";
  };

  services.miniflux-local = {
    enable = true;
    host = "nix-lab";
  };

  networking.hostName = "nix-lab";
  system.stateVersion = "24.05";
}
