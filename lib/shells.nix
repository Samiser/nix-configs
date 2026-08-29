{ inputs }:
let
  mkShell =
    system:
    let
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      nix = pkgs.nixVersions.latest;
    in
    pkgs.mkShell {
      packages = [
        inputs.agenix.packages.${system}.default
        inputs.deploy-rs.packages.${system}.default
        pkgs.git
        pkgs.nixfmt
        pkgs.statix
        pkgs.deadnix
        pkgs.nix-fast-build
        pkgs.nix-eval-jobs
        (pkgs.nixos-rebuild.override { inherit nix; })
        nix
      ];
    };
in
{
  x86_64-linux.default = mkShell "x86_64-linux";
  aarch64-darwin.default = mkShell "aarch64-darwin";
}
