{ pkgs, ... }:
{
  systemd.services.tailscale-set-operator = {
    description = "Set sam as the Tailscale operator";
    after = [ "tailscaled.service" ];
    wants = [ "tailscaled.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.tailscale}/bin/tailscale set --operator=sam";
    };
  };
}
