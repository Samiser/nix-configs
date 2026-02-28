{pkgs, ...}: {
  systemd.services.flaresolverr = {
    description = "FlareSolverr - Cloudflare bypass proxy";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];

    serviceConfig = {
      Type = "simple";
      DynamicUser = true;
      StateDirectory = "flaresolverr";
      ExecStart = "${pkgs.flaresolverr}/bin/flaresolverr";
      Restart = "on-failure";
      Environment = [
        "LOG_LEVEL=info"
        "HOST=127.0.0.1"
        "PORT=8191"
        "HOME=/var/lib/flaresolverr"
      ];
    };
  };

  environment.systemPackages = [pkgs.flaresolverr];
}
