{...}: {
  imports = [
    ./hyprland.nix
    ./services/caddy.nix
    ./services/ssc.nix
    ./services/gpa-calc.nix
    ./services/miniflux.nix
    ./services/markovi.nix
    ./services/attic.nix
    ./services/github-runner.nix
    ./services/sambee-fps.nix
    ./services/monitoring-agent.nix
    ./services/tailscale-auth.nix
  ];
}
