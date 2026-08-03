{
  config,
  lib,
  pkgs,
  keys,
  ...
}:
{
  config = lib.mkIf config.host.profile.server {
    boot.tmp.cleanOnBoot = true;
    zramSwap.enable = true;

    system.tools = {
      nixos-rebuild.enable = false;
      nixos-generate-config.enable = false;
    };

    environment.defaultPackages = [ ];

    boot.initrd.systemd.enable = true;
    system.etc.overlay.enable = true;
    services.userborn.enable = true;
    documentation.info.enable = false;

    services.openssh.hostKeys = [
      {
        path = "/var/lib/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
      {
        path = "/var/lib/ssh/ssh_host_rsa_key";
        type = "rsa";
        bits = 4096;
      }
    ];

    services.closured.enable = true;
    services.monitoring-agent.enable = true;
    services.tailscale-auth.enable = true;

    environment.systemPackages = with pkgs; [
      ghostty.terminfo
      (lib.lowPrio gitMinimal)
    ];

    users.users.root.openssh.authorizedKeys.keys = [ keys.sam ];
  };
}
