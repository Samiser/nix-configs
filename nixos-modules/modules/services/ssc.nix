{
  config,
  lib,
  pkgs,
  static-site-compiler,
  ...
}:
let
  inherit (import ../../../shared-modules/lib.nix) cloudflareTls;
  cfg = config.services.ssc;
  ssc = static-site-compiler.packages.${pkgs.stdenv.hostPlatform.system}.default;
  contentDir = "/var/lib/ssc/site-content";
in {
  options.services.ssc = {
    enable = lib.mkEnableOption "static site compiler service";

    domain = lib.mkOption {
      type = lib.types.str;
      description = "Domain to serve the site on";
      example = "samiser.xyz";
    };

    siteDir = lib.mkOption {
      type = lib.types.path;
      default = "/srv/blog";
      description = "Directory to output the built site";
    };

    contentRepo = lib.mkOption {
      type = lib.types.str;
      default = "https://github.com/Samiser/site-content";
      description = "Git repository containing site content";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [{
      assertion = config.services.caddy.enable;
      message = "services.ssc requires caddy to be enabled";
    }];

    users.groups.ssc = {};

    users.users.ssc = {
      isSystemUser = true;
      home = "/var/lib/ssc";
      createHome = true;
      group = "ssc";
    };

    age.secrets.ssc-secrets = {
      file = ../../../secrets/ssc-secrets.age;
      owner = "ssc";
      group = "ssc";
      mode = "0400";
    };

    systemd.services.ssc-build = {
      description = "Build static site with static-site-compiler";
      after = ["network-online.target"];
      wants = ["network-online.target"];

      path = [pkgs.git];

      script = ''
        set -eu

        if [ ! -d "${contentDir}/.git" ]; then
          echo "cloning site-content repo..."
          git clone ${cfg.contentRepo} "${contentDir}"
        else
          echo "updating site-content repo..."
          git -C "${contentDir}" pull --ff-only
        fi

        echo "running ssc..."
        ${ssc}/bin/ssc \
          --pages "${contentDir}/pages" \
          --blog-posts "${contentDir}/blog-posts" \
          --dive-log "${contentDir}/dives.uddf" \
          --secrets "${config.age.secrets.ssc-secrets.path}" \
          --out "${cfg.siteDir}"

        echo "ssc build complete"
      '';
    };

    systemd.timers.ssc-build = {
      description = "Run the ssc-build service every minute";
      wantedBy = ["timers.target"];
      timerConfig = {
        OnBootSec = "1min";
        OnUnitActiveSec = "1min";
        Unit = "ssc-build.service";
      };
    };

    environment.systemPackages = [ssc];

    services.caddy.virtualHosts."${cfg.domain} www.${cfg.domain}".extraConfig = cloudflareTls ''
      root * ${cfg.siteDir}
      file_server
    '';
  };
}
