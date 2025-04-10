{pkgs, ...}: {
  services.pulseaudio = {
    enable = false;
    package = pkgs.pulseaudioFull;
  };

  environment.systemPackages = with pkgs; [pavucontrol];
}
