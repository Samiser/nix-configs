{lib, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../../nixos-modules/config.nix
    ../../nixos-modules/users.nix
    ../../shared-modules/garnix.nix
    ../../nixos-modules/pkgs.nix
    ../../nixos-modules/agenix.nix
    ../../nixos-modules/services/tailscale.nix
    ./caddy.nix
    ./ssc.nix
    ./gpa-calc.nix
  ];

  systemd = {
    network.enable = true;

    network.networks."10-wan" = {
      matchConfig.Name = "eth0";
      networkConfig.DHCP = "yes";
    };

    services.systemd-networkd-wait-online.enable = lib.mkForce false;
  };

  networking = {
    useNetworkd = true;
    hostName = "nix-lab";
    domain = "";
  };

  # Custom host config
  hostConfig = {
    gui.enable = false;
  };

  nixpkgs.config.allowUnfree = true;

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDq1QymyXXTarJHQYXQ83Tg4ZAy4EeCrQvZ8nq5Rs/9ZK8Gznkc0eVF0rF/dW5P+a2DJPefYfBsaYS6BFxJwkxSLK1m2hk/rXMsAMviWbN4gtsWtLCqk7tl6sEMuxkUfaFwU5rMevdNNC9dgY2J4216xjTBvtXNkMjjAfnOmVUk2lyq1VxgyKyL4JhJvB/ZUGbmf8q07JPnka4VuxEhYkbWxm9e00LJ61QYxRRIYM6xBNsjBp3n+GUUEeWEPJKCvPZGTzIdTXXWUFAAcTOqxAtb9vtvgnbI63HU21A4KXRm1aS+VPusgofb5qP/CXfLUCfMpPadXAyUFH1ZXAchSxH0tPkgb1AWQdBYrXX/aD2/cyQFpZAGPe5JOWHSfPaRpHvOJvErEimVBdZOkhGV10ustcM0kJcZEH2zBOrMJrsD7wr+HNoxC8TdW7YyoCvu3H624WqDxSyvepwx4XbXx1Ezlwec8QWi0JIjTjP9RHaCYAgEk3FBK54Bsq/iX5EIwC0= sam@khaos"
  ];

  system.stateVersion = "24.05";
}
