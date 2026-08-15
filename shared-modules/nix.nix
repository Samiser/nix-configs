{ pkgs, ... }:
{
  nix = {
    package = pkgs.nixVersions.latest;

    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [
        "https://cache.samiser.xyz/main"
      ];
      trusted-public-keys = [
        "main:xTlqL+c6HRCxNLtRdVu+TElyY+HD9WiXQn0fSetkbFk="
      ];
      # Requested when available, transparently falls back to HTTP/2 or HTTP/1.1.
      http3 = true;
    };
  };

  nixpkgs.config.allowUnfree = true;
}
