{pkgs, ...}: {
  hardware.pulseaudio = {
    enable = false;
    package = pkgs.pulseaudioFull;
  };
}
