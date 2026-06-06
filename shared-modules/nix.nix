_: {
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    substituters = [
      "https://cache.samiser.xyz/main"
      "https://cache.garnix.io"
    ];
    trusted-public-keys = [
      "main:xTlqL+c6HRCxNLtRdVu+TElyY+HD9WiXQn0fSetkbFk="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    ];
  };

  nixpkgs.config.allowUnfree = true;
}
