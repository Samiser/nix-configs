_: let
  inherit (import ../../shared-modules/lib.nix) cloudflareTls;
in {
  services.jellyfin.enable = true;

  services.caddy.virtualHosts."jelly.vuvs.org".extraConfig = cloudflareTls ''
    reverse_proxy localhost:8096
  '';
}
