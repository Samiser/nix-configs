{ lib, nix-security-tracker, ... }:
{
  imports = [ "${nix-security-tracker}/nix/dev-setup.nix" ];

  nix-security-tracker-dev-environment.user = lib.mkDefault "sam";
}
