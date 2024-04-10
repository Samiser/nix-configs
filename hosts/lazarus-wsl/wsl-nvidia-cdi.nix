{ pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [ nvidia-container-toolkit ];

  virtualisation.containers.cdi.dynamic.nvidia.enable = true;

  programs.nix-ld.enable = true;

  environment.variables = lib.mkForce {
    NIX_LD_LIBRARY_PATH = "/usr/lib/wsl/lib/";
    NIX_LD = "${pkgs.glibc}/lib/ld-linux-x86-64.so.2";
  };

  # this is insane and will likely break at some point. created by running
  #
  #   nvidia-ctk cdi generate --format json
  #
  # on a different WSL VM, converting from json to nix, and editing the path of nvidia-ctk manually

  virtualisation.containers.cdi.static = {
    nvidia-gpu = {
      cdiVersion = "0.3.0";
      containerEdits = {
        hooks = [
          {
            args = [
              "nvidia-ctk"
              "hook"
              "create-symlinks"
              "--link"
              "/usr/lib/wsl/drivers/nv_dispig.inf_amd64_1fea8972dc2f0a69/nvidia-smi::/usr/bin/nvidia-smi"
            ];
            hookName = "createContainer";
            path = "/run/current-system/sw/bin/nvidia-ctk";
          }
          {
            args = [
              "nvidia-ctk"
              "hook"
              "update-ldcache"
              "--folder"
              "/usr/lib/wsl/drivers/nv_dispig.inf_amd64_1fea8972dc2f0a69"
              "--folder"
              "/usr/lib/wsl/lib"
            ];
            hookName = "createContainer";
            path = "/run/current-system/sw/bin/nvidia-ctk";
          }
        ];
        mounts = [
          {
            containerPath = "/usr/lib/wsl/lib/libdxcore.so";
            hostPath = "/usr/lib/wsl/lib/libdxcore.so";
            options = [
              "ro"
              "nosuid"
              "nodev"
              "bind"
            ];
          }
          {
            containerPath = "/usr/lib/wsl/drivers/nv_dispig.inf_amd64_1fea8972dc2f0a69/libcuda.so.1.1";
            hostPath = "/usr/lib/wsl/drivers/nv_dispig.inf_amd64_1fea8972dc2f0a69/libcuda.so.1.1";
            options = [
              "ro"
              "nosuid"
              "nodev"
              "bind"
            ];
          }
          {
            containerPath = "/usr/lib/wsl/drivers/nv_dispig.inf_amd64_1fea8972dc2f0a69/libcuda_loader.so";
            hostPath = "/usr/lib/wsl/drivers/nv_dispig.inf_amd64_1fea8972dc2f0a69/libcuda_loader.so";
            options = [
              "ro"
              "nosuid"
              "nodev"
              "bind"
            ];
          }
          {
            containerPath = "/usr/lib/wsl/drivers/nv_dispig.inf_amd64_1fea8972dc2f0a69/libnvidia-ml.so.1";
            hostPath = "/usr/lib/wsl/drivers/nv_dispig.inf_amd64_1fea8972dc2f0a69/libnvidia-ml.so.1";
            options = [
              "ro"
              "nosuid"
              "nodev"
              "bind"
            ];
          }
          {
            containerPath = "/usr/lib/wsl/drivers/nv_dispig.inf_amd64_1fea8972dc2f0a69/libnvidia-ml_loader.so";
            hostPath = "/usr/lib/wsl/drivers/nv_dispig.inf_amd64_1fea8972dc2f0a69/libnvidia-ml_loader.so";
            options = [
              "ro"
              "nosuid"
              "nodev"
              "bind"
            ];
          }
          {
            containerPath = "/usr/lib/wsl/drivers/nv_dispig.inf_amd64_1fea8972dc2f0a69/libnvidia-ptxjitcompiler.so.1";
            hostPath = "/usr/lib/wsl/drivers/nv_dispig.inf_amd64_1fea8972dc2f0a69/libnvidia-ptxjitcompiler.so.1";
            options = [
              "ro"
              "nosuid"
              "nodev"
              "bind"
            ];
          }
          {
            containerPath = "/usr/lib/wsl/drivers/nv_dispig.inf_amd64_1fea8972dc2f0a69/nvcubins.bin";
            hostPath = "/usr/lib/wsl/drivers/nv_dispig.inf_amd64_1fea8972dc2f0a69/nvcubins.bin";
            options = [
              "ro"
              "nosuid"
              "nodev"
              "bind"
            ];
          }
          {
            containerPath = "/usr/lib/wsl/drivers/nv_dispig.inf_amd64_1fea8972dc2f0a69/nvidia-smi";
            hostPath = "/usr/lib/wsl/drivers/nv_dispig.inf_amd64_1fea8972dc2f0a69/nvidia-smi";
            options = [
              "ro"
              "nosuid"
              "nodev"
              "bind"
            ];
          }
        ];
      };
      devices = [
        {
          containerEdits = {
            deviceNodes = [ { path = "/dev/dxg"; } ];
          };
          name = "all";
        }
      ];
      kind = "nvidia.com/gpu";
    };
  };
}
