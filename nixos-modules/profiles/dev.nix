{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.host.profile.dev {
    environment.systemPackages = with pkgs; [
      docker-compose
      entr
      nixfmt
      nix-tree
      pv
      python3
      stow
    ];
  };
}
