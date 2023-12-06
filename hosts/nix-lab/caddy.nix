{ config, pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.caddy = {
    enable = true;
    virtualHosts = {
      "vuvs.org" = {
        extraConfig = ''
          respond "Hello World"
        '';
      };
    };
  };
}

