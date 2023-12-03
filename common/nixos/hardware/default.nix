{ config, pkgs, ... }:

{
  imports = [
    ./bluetooth.nix
    ./nvidia-optimus.nix
    ./pulseaudio.nix
    ./opengl.nix
  ];
}
