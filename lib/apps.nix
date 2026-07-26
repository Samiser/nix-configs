{ inputs }:
let
  mkApp =
    system:
    let
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      closure-sizes = pkgs.writeShellApplication {
        name = "closure-sizes";
        runtimeInputs = [
          pkgs.python3
          pkgs.nix
        ];
        text = ''
          exec python3 ${./closure-sizes.py} "$@"
        '';
      };
    in
    {
      closure-sizes = {
        type = "app";
        program = "${closure-sizes}/bin/closure-sizes";
      };
    };
in
{
  x86_64-linux = mkApp "x86_64-linux";
  aarch64-darwin = mkApp "aarch64-darwin";
}
