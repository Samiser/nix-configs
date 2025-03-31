{
  pkgs,
  lib,
  ...
}: {
  fonts.packages = with pkgs; [nerd-fonts.fira-code];
}
