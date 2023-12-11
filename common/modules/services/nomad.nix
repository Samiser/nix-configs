{ lib, config, pkgs, ... }:

{
  services.nomad = {
    enable = true;
    extraSettingsPlugins = [ pkgs.nomad-driver-podman ];
    dropPrivileges = false;
    settings = {
      bind_addr = "100.104.0.9";
      server = {
        enabled = true;
        bootstrap_expect = 1;
      };
      client = {
        enabled = true;
        options = {
          "driver.podman.enable" = "1";
        };
      };
    };
  };
}
