{...}: {
  imports = [
    ./hardware-configuration.nix
    ../../shared-modules/garnix.nix
    ../../nixos-modules/modules
    ../../nixos-modules/profiles/base.nix
    ../../nixos-modules/profiles/desktop.nix
    ../../nixos-modules/profiles/pkgs.nix
  ];

  hostConfig = {
    i3.enable = true;
    vm = true;
  };

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

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDq1QymyXXTarJHQYXQ83Tg4ZAy4EeCrQvZ8nq5Rs/9ZK8Gznkc0eVF0rF/dW5P+a2DJPefYfBsaYS6BFxJwkxSLK1m2hk/rXMsAMviWbN4gtsWtLCqk7tl6sEMuxkUfaFwU5rMevdNNC9dgY2J4216xjTBvtXNkMjjAfnOmVUk2lyq1VxgyKyL4JhJvB/ZUGbmf8q07JPnka4VuxEhYkbWxm9e00LJ61QYxRRIYM6xBNsjBp3n+GUUEeWEPJKCvPZGTzIdTXXWUFAAcTOqxAtb9vtvgnbI63HU21A4KXRm1aS+VPusgofb5qP/CXfLUCfMpPadXAyUFH1ZXAchSxH0tPkgb1AWQdBYrXX/aD2/cyQFpZAGPe5JOWHSfPaRpHvOJvErEimVBdZOkhGV10ustcM0kJcZEH2zBOrMJrsD7wr+HNoxC8TdW7YyoCvu3H624WqDxSyvepwx4XbXx1Ezlwec8QWi0JIjTjP9RHaCYAgEk3FBK54Bsq/iX5EIwC0= sam@khaos"
  ];

  system.stateVersion = "24.05";
}
