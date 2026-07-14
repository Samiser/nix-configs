{
  config,
  lib,
  pkgs,
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
      serviceOverrides = {
        # Allow deploy jobs to write to the app's state directory.
        ReadWritePaths = ["/var/lib/sambee"];
        # Point <nixpkgs> at the same source that builds this system so
        # build jobs (nix-shell / import <nixpkgs>) can resolve it.
        Environment = ["NIX_PATH=nixpkgs=${pkgs.path}"];
      };
    };
  };
}
