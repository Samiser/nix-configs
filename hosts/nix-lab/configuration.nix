{ ... }: {
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

    storagebox = {
      enable = true;
      user = "root";
      group = "root";
      fileMode = "0666";
      dirMode = "0777";
    };

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

    markovi.enable = true;

    attic-cache.enable = true;

    sambee-runner.enable = true;
    sambee-fps.enable = true;
  };

  networking.hostName = "nix-lab";
  system.stateVersion = "24.05";
}
