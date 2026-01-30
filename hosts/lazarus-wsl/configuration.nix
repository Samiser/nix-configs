{nixos-wsl, ...}: {
  imports = [
    nixos-wsl.nixosModules.wsl
    ../../nixos-modules/modules
    ../../nixos-modules/profiles/base.nix
    ../../nixos-modules/profiles/pkgs.nix
    ../../shared-modules/garnix.nix
    ./wsl-nvidia-cdi.nix
  ];

  services.tailscale-local.enable = true;

  wsl = {
    enable = true;
    defaultUser = "sam";
    extraBin = [
      {
        src = "/usr/lib/wsl/lib/nvidia-smi";
      }
    ];
  };

  networking.hostName = "lazarus-wsl";

  system.stateVersion = "23.05";
}
