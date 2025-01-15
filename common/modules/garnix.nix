{lib, ...}: {
  nix.settings.substituters = lib.mkAfter [
    "https://cache.garnix.io"
  ];

  nix.settings.trusted-public-keys = lib.mkAfter [
    "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
  ];
}
