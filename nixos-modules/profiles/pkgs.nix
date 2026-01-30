# Common CLI packages for all hosts
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # cli tools
    _1password-cli
    acpi
    dig
    fd
    ffmpeg
    fzf
    imagemagick
    jq
    pciutils
    playerctl
    pv
    ripgrep
    stow
    sysstat
    tree
    unzip
    wget
    wireguard-tools
    xclip
    zsh

    # dev
    direnv
    docker-compose
    entr
    git
    nixfmt
    python3
    tcpdump
    ghostty.terminfo

    # tui
    gotop
    htop
    neofetch
    nix-tree
    tmux
  ];
}
