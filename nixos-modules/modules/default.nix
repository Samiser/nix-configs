# Import all modules - hosts import this once to get all module options
{...}: {
  imports = [
    ./host-config.nix
    ./i3.nix
    ./services/caddy.nix
    ./services/ssc.nix
    ./services/gpa-calc.nix
    ./services/miniflux.nix
    ./services/tailscale.nix
    ../hardware/vm-guest.nix
  ];
}
