{ pkgs, ... }:
{
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware = {
    nvidia = {
      open = true;
      modesetting.enable = true;
      powerManagement = {
        enable = true;
        kernelSuspendNotifier = false;
      };
    };
    graphics.extraPackages = [ pkgs.nvidia-vaapi-driver ];
  };
}
