{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../common/config.nix
    ../../common/users
    ../../common/garnix.nix
    ../../common/modules/pkgs.nix
    ../../common/modules/agenix.nix
    ../../common/modules/services/tailscale.nix
  ];

  virtualisation.podman.enable = true;
  systemd = {
    network.enable = true;

    network.networks."10-wan" = {
      matchConfig.Name = "eth0";
      networkConfig.DHCP = "yes";
    };

    services.systemd-networkd-wait-online.enable = lib.mkForce false;

    services.storageRoute = {
      wantedBy = ["multi-user.target"];
      after = ["network.target"];
      description = "Route requests to my Hetzner storage box via default routes";
      path = [pkgs.bash pkgs.iproute];
      script = ''
        if ! (ip rule | grep "46.4.0.0" -q); then
          ip rule add to 46.4.0.0/16 lookup main pref 5000
          ip rule add to 46.4.0.0/16 lookup default pref 5010
        fi
      '';
      serviceConfig = {
        Type = "oneshot";
        User = "root";
        Restart = "no";
      };
    };
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

  age.secrets.nomad-samba-credentials = {
    file = ../../secrets/nomad-samba-credentials.age;
    path = "/etc/nixos/smb-secrets";
  };

  environment.systemPackages = with pkgs; [cifs-utils neovim tmux];
  fileSystems."/mnt/hz" = {
    device = "//u361974-sub2.your-storagebox.de/u361974-sub2";
    fsType = "cifs";
    options = let
      # this line prevents hanging on network split
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
    in [
      "${automount_opts},credentials=/etc/nixos/smb-secrets,uid=1000,gid=1000"
    ];
  };

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDq1QymyXXTarJHQYXQ83Tg4ZAy4EeCrQvZ8nq5Rs/9ZK8Gznkc0eVF0rF/dW5P+a2DJPefYfBsaYS6BFxJwkxSLK1m2hk/rXMsAMviWbN4gtsWtLCqk7tl6sEMuxkUfaFwU5rMevdNNC9dgY2J4216xjTBvtXNkMjjAfnOmVUk2lyq1VxgyKyL4JhJvB/ZUGbmf8q07JPnka4VuxEhYkbWxm9e00LJ61QYxRRIYM6xBNsjBp3n+GUUEeWEPJKCvPZGTzIdTXXWUFAAcTOqxAtb9vtvgnbI63HU21A4KXRm1aS+VPusgofb5qP/CXfLUCfMpPadXAyUFH1ZXAchSxH0tPkgb1AWQdBYrXX/aD2/cyQFpZAGPe5JOWHSfPaRpHvOJvErEimVBdZOkhGV10ustcM0kJcZEH2zBOrMJrsD7wr+HNoxC8TdW7YyoCvu3H624WqDxSyvepwx4XbXx1Ezlwec8QWi0JIjTjP9RHaCYAgEk3FBK54Bsq/iX5EIwC0= sam@khaos"
  ];

  system.stateVersion = "24.05";
}
