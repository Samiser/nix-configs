_: {
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    substituters = [
      "https://cache.samiser.xyz/main"
      "https://noctalia.cachix.org"
    ];
    trusted-public-keys = [
      "main:xTlqL+c6HRCxNLtRdVu+TElyY+HD9WiXQn0fSetkbFk="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

  nixpkgs.config.allowUnfree = true;
}
