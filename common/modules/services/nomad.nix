{ lib, config, pkgs, ... }:

{
  services.nomad = {
    enable = true;
    enableDocker = true;
    dropPrivileges = true;
    settings = {
      bind_addr = "100.104.0.9";
      server = {
        enabled = true;
        bootstrap_expect = 1;
      };
      client = {
        enabled = true;
      };
    };
  };
}
