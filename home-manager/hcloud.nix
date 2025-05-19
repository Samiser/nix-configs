{
  config,
  pkgs,
  ...
}: {
  age.secrets.hcloud-token = {
    file = ../secrets/hcloud-token.age;
    path = "${config.home.homeDirectory}/.config/hcloud/cli.toml";
  };

  home.packages = [pkgs.hcloud];
}
