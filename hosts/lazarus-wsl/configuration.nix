{ config, lib, pkgs, nixos-wsl, ... }:

{
  imports = [
    nixos-wsl.nixosModules.wsl
    ../../common/users
    ../../common/users/home-manager.nix
    ../../common/modules/services/tailscale.nix
    ../../common/modules/services/openssh.nix
    ../../common/config.nix
    ../../common/modules/pkgs.nix
  ];

  wsl.enable = true;
  wsl.defaultUser = "sam";
  
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
