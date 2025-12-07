{
  pkgs,
  config,
  static-site-compiler,
  ...
}: let
  ssc = static-site-compiler.packages.${pkgs.system}.default;
  contentDir = "/var/lib/ssc/site-content";
  siteDir = "/srv/blog";
in {
  users.groups.ssc = {};

  users.users.ssc = {
    isSystemUser = true;
    home = "/var/lib/ssc";
    createHome = true;
    group = "ssc";
  };

  age.secrets.ssc-secrets = {
    file = ../../secrets/ssc-secrets.age;
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
        git clone https://github.com/Samiser/site-content "${contentDir}"
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
        --out "${siteDir}"

      echo "ssc build complete"
    '';
  };

  systemd.timers.ssc-build = {
    description = "Run the ssc-build service (building the static site) every minute";
    wantedBy = ["timers.target"];
    timerConfig = {
      OnBootSec = "1min";
      OnUnitActiveSec = "1min";
      Unit = "ssc-build.service";
    };
  };

  environment.systemPackages = [
    ssc
  ];
}
