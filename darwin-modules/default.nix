{
  imports = [
    ./nix/build-machines.nix
    ../shared-modules/pkgs.nix
    ./system
    ./services
  ];
}
