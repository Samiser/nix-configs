{
  lib,
  pkgs,
  osConfig,
  ...
}:
{
  config = lib.mkIf (pkgs.stdenv.hostPlatform.isLinux && osConfig.host.profile.desktop) {
    xdg.configFile."wl-kbptr/config".text = ''
      [general]
      modes=floating,click

      [mode_floating]
      source=detect
    '';
  };
}
