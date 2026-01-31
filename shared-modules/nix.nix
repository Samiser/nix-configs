{lib, ...}: {
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    substituters = lib.mkAfter ["https://cache.garnix.io"];
    trusted-public-keys = lib.mkAfter ["cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="];
    trusted-substituters = lib.mkAfter ["ssh-ng://sam@nix-lab.dove-delta.ts.net"];
  };
}
