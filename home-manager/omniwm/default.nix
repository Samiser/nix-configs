{ lib, pkgs, ... }:
{
  config = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    xdg.configFile."omniwm/settings.toml" = {
      source = ./settings.toml;
      force = true;
    };
  };
}
