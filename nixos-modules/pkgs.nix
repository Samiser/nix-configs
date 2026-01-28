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
      feh
      gimp
      godot_4
      mpv
      mupdf
      scrot
      obsidian
      peek
      #virt-manager
      #networkmanagerapplet
    ]
    ++ lib.optionals (guiEnabled
      && pkgs.stdenv.hostPlatform.system
      == "x86_64-linux") [
      spotify
      steam
      discord
    ];

  # allow unfree
  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.permittedInsecurePackages = ["python-2.7.18.8" "electron-24.8.6"];

  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  #virtualisation.libvirtd.enable = true;
  virtualisation.docker.enable = true;
}
