{keys, ...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  host.profile = {
    desktop = true;
    vm = true;
  };

  hostConfig.i3.enable = true;

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    tmp.cleanOnBoot = true;
  };

  virtualisation.podman.enable = true;

  networking = {
    useNetworkd = true;
    hostName = "utm-vm";
  };

  users.users.root.openssh.authorizedKeys.keys = [keys.sam];

  system.stateVersion = "24.05";
}
