{
  config,
  lib,
  ...
}: let
  cfg = config.services.sambee-runner;
in {
  options.services.sambee-runner = {
    enable = lib.mkEnableOption "GitHub Actions runner for wookbee/sambee-fps";
  };

  config = lib.mkIf cfg.enable {
    age.secrets.github-runner-sambee = {
      file = ../../../secrets/github-runner-sambee.age;
    };

    users.users.sambee-runner = {
      isSystemUser = true;
      group = "sambee-runner";
    };
    users.groups.sambee-runner = {};

    services.github-runners.sambee = {
      enable = true;
      url = "https://github.com/wookbee/sambee-fps";
      name = "nix-lab";
      extraLabels = ["nix-lab"];
      tokenFile = config.age.secrets.github-runner-sambee.path;
      user = "sambee-runner";
      group = "sambee-runner";
      # Allow deploy jobs to write to the app's state directory.
      serviceOverrides.ReadWritePaths = ["/var/lib/sambee"];
    };
  };
}
