{
  pkgs,
  lib,
  config,
  ...
}: {
  fonts = lib.mkIf config.hostConfig.gui.enable {
    packages = with pkgs; [nerd-fonts.jetbrains-mono];
    fontconfig = {
      defaultFonts = {
        monospace = ["JetBrainsMono Nerd Font Mono"];
      };
    };
  };
}
