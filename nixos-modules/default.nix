{...}: {
  imports = [
    ./config.nix
    ./users.nix
    ./pkgs.nix
    ./services
    ./vm-guest.nix
    ./i3.nix
    ./opengl.nix
    ./1password.nix
    ./fonts.nix
  ];
}
