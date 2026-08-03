{ pkgs, ... }:
let
  dashboardPage = pkgs.writeTextDir "index.html" ''
    <!DOCTYPE html>
    <html>
    <head>
      <title>Radar</title>
      <style>
        body { font-family: sans-serif; max-width: 400px; margin: 50px auto; }
        a { display: block; padding: 12px; margin: 8px 0; background: #333; color: #fff; text-decoration: none; border-radius: 4px; }
        a:hover { background: #555; }
      </style>
    </head>
    <body>
      <h1>Radar</h1>
      <a href="http://radar:7878">Radarr (Movies)</a>
      <a href="http://radar:8989">Sonarr (TV)</a>
      <a href="http://radar:9696">Prowlarr (Indexers)</a>
      <a href="http://radar:8181">qBittorrent</a>
      <a href="http://radar:5055">Jellyseerr (Requests)</a>
    </body>
    </html>
  '';
in
{
  services.nginx = {
    enable = true;
    virtualHosts."radar" = {
      listen = [
        {
          addr = "0.0.0.0";
          port = 80;
        }
      ];
      root = dashboardPage;
    };
  };

  # Bind nginx to Tailscale interface
  systemd.services.nginx = {
    after = [ "tailscaled.service" ];
    wants = [ "tailscaled.service" ];
    serviceConfig.ExecStartPre = pkgs.writeShellScript "nginx-wait-tailscale" ''
      until ${pkgs.tailscale}/bin/tailscale status &>/dev/null; do sleep 1; done
    '';
  };

  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 80 ];
}
