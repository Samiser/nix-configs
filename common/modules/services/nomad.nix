{ lib, config, pkgs, ... }:

{
  options.nomad.bind_addr = lib.mkOption {
    type = lib.types.str;
    default = "127.0.0.1";
  };

  config.environment.variables = {
    NOMAD_ADDR = "http://${config.nomad.bind_addr}:4646";
  };

  config.services.nomad = {
    enable = true;
    extraSettingsPlugins = [ pkgs.nomad-driver-podman ];
    extraPackages = [ pkgs.cni-plugins ];
    dropPrivileges = false;
    settings = {
      acl = {
        enabled = true;
      };
      bind_addr = config.nomad.bind_addr;
      server = {
        enabled = true;
        bootstrap_expect = 1;
      };
      client = {
        enabled = true;
        cni_path = "${pkgs.cni-plugins}/bin";
        options = {
          "driver.podman.enable" = "1";
        };
      };
    };
  };
}
