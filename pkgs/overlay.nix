final: prev:
let
  vendored =
    name: path:
    if prev ? ${name} then
      throw "pkgs.${name} is in nixpkgs now, drop pkgs/by-name/*/${name} and its overlay entry"
    else
      final.callPackage path { };
in
{
  omniwm = vendored "omniwm" ./by-name/om/omniwm/package.nix;
}
