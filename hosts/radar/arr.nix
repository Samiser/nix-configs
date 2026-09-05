_:
let
  arrPorts = {
    radarr = 7878;
    sonarr = 8989;
    prowlarr = 9696;
  };
in
{
  services = builtins.mapAttrs (_: _: {
    enable = true;
    openFirewall = false;
  }) arrPorts;

  users.users.sonarr.extraGroups = [ "radarr" ];

  networking.firewall.interfaces.tailscale0.allowedTCPPorts = builtins.attrValues arrPorts;
}
