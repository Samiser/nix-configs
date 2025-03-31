{
  config,
  pkgs,
  lib,
  ...
}: let
  guiEnabled = config.hostConfig.gui.enable;
in {
  environment.systemPackages = with pkgs;
    [
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
      starship
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
      hcloud
      nixfmt-rfc-style
      python
      rust-analyzer
      tcpdump

      # tui
      gotop
      htop
      neofetch
      nix-tree
      tmux
    ]
    ++ lib.optionals guiEnabled [
      alacritty
      arandr
      chromium
      dconf
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
      steam
      networkmanagerapplet
    ];

  # allow unfree
  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.permittedInsecurePackages = ["python-2.7.18.7" "python-2.7.18.8" "electron-24.8.6"];

  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  virtualisation.libvirtd.enable = true;
  virtualisation.podman.enable = true;
}
