{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:
{
  config = lib.mkIf (!osConfig.host.profile.server) {
    age.secrets.hcloud-token.file = ../secrets/hcloud-token.age;

    home.packages = [
      (pkgs.writeShellScriptBin "hcloud" ''
        HCLOUD_TOKEN=$(cat ${config.age.secrets.hcloud-token.path}) \
          exec ${pkgs.hcloud}/bin/hcloud "$@"
      '')
    ];
  };
}
