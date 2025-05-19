{nixos-wsl, ...}: {
  imports = [
    nixos-wsl.nixosModules.wsl
    ../../nixos-modules/users.nix
    ../../nixos-modules/services/nomad.nix
    ../../nixos-modules/services/tailscale.nix
    ../../nixos-modules/services/openssh.nix
    ../../shared-modules/garnix.nix
    ../../nixos-modules/config.nix
    ../../nixos-modules/pkgs.nix
    ./wsl-nvidia-cdi.nix
  ];

  nomad = {
    bind_addr = "100.120.228.44";
    client = true;
    nvidia = true;
  };

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

  # Custom host config
  hostConfig = {
    gui.enable = false;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
