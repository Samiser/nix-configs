{ lib, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../common/modules/services/nomad.nix
  ];

  virtualisation.podman.enable = true;

  systemd.network.enable = true;
  systemd.network.networks."10-wan" = {
    matchConfig.Name = "eth0";
    networkConfig.DHCP = "yes";
  };

  nomad.bind_addr = "100.104.0.9";

  systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;

  services.tailscale.enable = true;

  age.secrets.nomad-samba-credentials = {
    file = ../../secrets/nomad-samba-credentials.age;
    path = "/etc/nixos/smb-secrets";
  };

  environment.systemPackages = [ pkgs.cifs-utils ];
  fileSystems."/mnt/hz" = {
    device = "//u361974-sub2.your-storagebox.de/u361974-sub2";
    fsType = "cifs";
    options = let
      # this line prevents hanging on network split
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
    in ["${automount_opts},credentials=/etc/nixos/smb-secrets"];
  };

  boot.cleanTmpDir = true;
  zramSwap.enable = true;
  networking.hostName = "nix-lab";
  networking.domain = "";
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDq1QymyXXTarJHQYXQ83Tg4ZAy4EeCrQvZ8nq5Rs/9ZK8Gznkc0eVF0rF/dW5P+a2DJPefYfBsaYS6BFxJwkxSLK1m2hk/rXMsAMviWbN4gtsWtLCqk7tl6sEMuxkUfaFwU5rMevdNNC9dgY2J4216xjTBvtXNkMjjAfnOmVUk2lyq1VxgyKyL4JhJvB/ZUGbmf8q07JPnka4VuxEhYkbWxm9e00LJ61QYxRRIYM6xBNsjBp3n+GUUEeWEPJKCvPZGTzIdTXXWUFAAcTOqxAtb9vtvgnbI63HU21A4KXRm1aS+VPusgofb5qP/CXfLUCfMpPadXAyUFH1ZXAchSxH0tPkgb1AWQdBYrXX/aD2/cyQFpZAGPe5JOWHSfPaRpHvOJvErEimVBdZOkhGV10ustcM0kJcZEH2zBOrMJrsD7wr+HNoxC8TdW7YyoCvu3H624WqDxSyvepwx4XbXx1Ezlwec8QWi0JIjTjP9RHaCYAgEk3FBK54Bsq/iX5EIwC0= sam@khaos"
  ];
}
