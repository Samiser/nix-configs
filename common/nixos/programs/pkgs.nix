{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # cli tools
    _1password
    acpi
    bc
    bubblewrap
    deploy-rs
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
    starship
    stow
    sysstat
    tree
    unzip
    wget
    wireguard-tools
    xclip

    # dev
    direnv
    docker-compose
    entr
    git
    hcloud
    python
    rust-analyzer

    # tui
    gotop
    htop
    neofetch
    nix-tree
    tmux

    # gui
    _1password-gui
    alacritty
    arandr
    chromium
    discord
    feh
    gimp
    godot_4
    mesa-demos
    mpv
    mupdf
    obsidian
    pavucontrol
    peek
    prismlauncher
    scrot
    spotify
    virt-manager
  ];

  # fonts
  fonts.fonts = with pkgs; [
    (nerdfonts.override {
      fonts = [
        "FiraCode"
      ];
    })
  ];

  # allow unfree
  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.permittedInsecurePackages = [
    "python-2.7.18.6"
    "electron-24.8.6"
  ];

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs = {
    steam.enable = true;
    nm-applet.enable = true;
    dconf.enable = true;
    zsh.enable = true;
  };

  virtualisation.libvirtd.enable = true;
  virtualisation.docker.enable = true;
}
