# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/7a22a33c-8039-4d71-b9a8-37ef34028ed5";
    fsType = "ext4";
  };

  boot.initrd.luks.devices = {
    cryptkey = {
      device = "/dev/disk/by-uuid/be301f86-951f-4133-9e65-0942533e6a98";
    };

    cryptroot = {
      device = "/dev/disk/by-uuid/a7a97704-6615-4f0e-a9a3-4ff92bf463b1";
      keyFile = "/dev/mapper/cryptkey";
    };

    cryptswap = {
      device = "/dev/disk/by-uuid/875e19f6-ffb2-49b8-a007-2b102460939d";
      keyFile = "/dev/mapper/cryptkey";
    };
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/AB9E-77B3";
    fsType = "vfat";
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/11b470c1-6f7f-4990-8bd1-68ee6ff0f5b0"; }];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  # high-resolution display
  #hardware.video.hidpi.enable = lib.mkDefault true;
}
