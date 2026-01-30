{nixos-wsl, ...}: {
  imports = [
    nixos-wsl.nixosModules.wsl
    ./wsl-nvidia-cdi.nix
  ];

  host.profile.dev = true;

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
