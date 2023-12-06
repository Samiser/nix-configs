{ config, pkgs, lib, ... }:

let
  guiEnabled = config.hostConfig.gui.enable;
in
{
  environment.systemPackages = with pkgs; [
    # cli tools
    _1password
    acpi
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
    nixfmt
    python
    rust-analyzer

    # tui
    gotop
    htop
    neofetch
    nix-tree
    tmux
  ] ++ lib.optionals guiEnabled [
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

  programs = {
    steam.enable = true;
    nm-applet.enable = true;
    dconf.enable = true;
    zsh.enable = true;
    starship.enable = true;
  };

  # allow unfree
  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.permittedInsecurePackages =
    [ "python-2.7.18.7" "electron-24.8.6" ];

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  virtualisation.libvirtd.enable = true;
  virtualisation.docker.enable = true;
}