{
  config,
  pkgs,
  ...
}:
{
  age.secrets.hcloud-token.file = ../secrets/hcloud-token.age;

  home.packages = [
    (pkgs.writeShellScriptBin "hcloud" ''
      HCLOUD_TOKEN=$(cat ${config.age.secrets.hcloud-token.path}) \
        exec ${pkgs.hcloud}/bin/hcloud "$@"
    '')
  ];
}
