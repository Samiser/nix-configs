_: {
  nix.settings = {
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
  };

  nixpkgs.config.allowUnfree = true;
}
