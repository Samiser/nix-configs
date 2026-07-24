{...}: {
  imports = [
    ./options.nix
    ./base.nix
    ./desktop.nix
    ./dev.nix
    ./monitoring-agent.nix
    ./server.nix
    ./tailscale-auth.nix
    ./vm.nix
  ];
}
