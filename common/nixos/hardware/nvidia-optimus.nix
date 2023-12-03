{ lib, pkgs, ... }:

{
  imports = [
    <nixos-hardware/common/gpu/nvidia/prime.nix>
  ];

  services.xserver.videoDrivers = [ "nvidia" ];
  boot.blacklistedKernelModules =  [ "nouveau" ];
  boot.kernelParams = lib.mkDefault [ "acpi_rev_override" ];

  hardware.nvidia = {
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
      intelBusId = "PCI:0:2:0";

      # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
      nvidiaBusId = "PCI:1:0:0";
    };

    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;    
  };
}
