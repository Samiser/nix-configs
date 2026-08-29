{
  config,
  lib,
  sharedLib,
  ...
}:
let
  inherit (sharedLib) cloudflareTls requiresCaddy;
  cfg = config.services.gpa-calc;
in
{
  options.services.gpa-calc = {
    enable = lib.mkEnableOption "GPA calculator service";

    domain = lib.mkOption {
      type = lib.types.str;
      description = "Domain to serve the app on";
      example = "gpa-calc.samiser.xyz";
    };

    image = lib.mkOption {
      type = lib.types.str;
      default = "ghcr.io/samiser/corona-gpa-calculator:latest";
      description = "Container image to run";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 5000;
      description = "Port the container listens on";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [ (requiresCaddy config "gpa-calc") ];

    virtualisation.oci-containers.containers.gpa-calc = {
      inherit (cfg) image;
      autoStart = true;
      ports = [ "127.0.0.1:${toString cfg.port}:${toString cfg.port}" ];
    };

    services.caddy.virtualHosts.${cfg.domain}.extraConfig = cloudflareTls ''
      reverse_proxy localhost:${toString cfg.port}
    '';
  };
}
