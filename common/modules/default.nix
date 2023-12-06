{ config, pkgs, ... }:

{
  imports = [
    ./1password.nix
    ./bluetooth.nix
    ./fonts.nix
    ./i3.nix
    ./nvidia-optimus.nix
    ./opengl.nix
    ./pkgs.nix
    ./pulseaudio.nix
    ./services
  ];
}
