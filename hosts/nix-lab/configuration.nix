{...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  host = {
    deploy.enable = true;
    profile = {
      dev = true;
      server = true;
    };
  };

  services = {
    caddy.enable = true;

    ssc = {
      enable = true;
      domain = "samiser.xyz";
    };

    gpa-calc = {
      enable = true;
      domain = "gpa-calc.samiser.xyz";
    };

    miniflux-local = {
      enable = true;
      host = "nix-lab";
    };
  };

  networking.hostName = "nix-lab";
  system.stateVersion = "24.05";
}
