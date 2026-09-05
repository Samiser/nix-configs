{ sharedLib, ... }:
let
  inherit (sharedLib) cloudflareTls;
in
{
  services.jellyfin.enable = true;

  services.caddy.virtualHosts."jelly.vuvs.org".extraConfig = cloudflareTls ''
    reverse_proxy localhost:8096
  '';
}
