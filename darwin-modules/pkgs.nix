{
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # cli tools
    _1password-cli
    fd
    ffmpeg
    neofetch
    ripgrep
    tmux
    tree

    # container runtime
    colima
    docker
  ];

  # allow unfree
  nixpkgs.config.allowUnfree = true;
}
