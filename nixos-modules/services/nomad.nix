{
  lib,
  config,
  pkgs,
  ...
}: {
  options.nomad = {
    bind_addr = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
    };

    server = lib.mkEnableOption "server";
    client = lib.mkEnableOption "client";
  };

  config.environment.variables = {
    NOMAD_ADDR = "http://${config.nomad.bind_addr}:4646";
  };

  config.services.nomad = {
    enable = true;
    extraSettingsPlugins = [
      pkgs.nomad-driver-podman
    ];
    extraPackages = [pkgs.cni-plugins];
    dropPrivileges = false;
    settings = {
      acl = {
        enabled = true;
      };
      bind_addr = config.nomad.bind_addr;
      server = {
        enabled = config.nomad.server;
        bootstrap_expect = 1;
      };
      client = {
        enabled = config.nomad.client;
        servers = ["100.104.0.9"];
        cni_path = "${pkgs.cni-plugins}/bin";
        options = {
          "driver.podman.enable" = "1";
        };
      };
    };
  };
}
