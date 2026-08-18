{
  imports = [
    ./nix/build-machines.nix
    ./system
    ./services
  ];

  nixpkgs.overlays = [ (import ../pkgs/overlay.nix) ];
}
