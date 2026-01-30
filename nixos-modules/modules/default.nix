{...}: {
  imports = [
    ./host-config.nix
    ./i3.nix
    ./services/caddy.nix
    ./services/ssc.nix
    ./services/gpa-calc.nix
    ./services/miniflux.nix
  ];
}
