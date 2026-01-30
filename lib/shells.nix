{inputs}: let
  mkShell = system: let
    pkgs = inputs.nixpkgs.legacyPackages.${system};
  in
    pkgs.mkShell {
      packages = [
        inputs.agenix.packages.${system}.default
        inputs.deploy-rs.packages.${system}.default
        pkgs.git
        pkgs.nixfmt
        pkgs.statix
        pkgs.deadnix
      ];
    };
in {
  x86_64-linux.default = mkShell "x86_64-linux";
  aarch64-darwin.default = mkShell "aarch64-darwin";
}
