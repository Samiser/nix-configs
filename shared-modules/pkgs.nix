{
  config,
  pkgs,
  lib,
  ...
}: let
  guiEnabled = config.hostConfig.gui.enable or false;
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
in {
  environment.systemPackages = with pkgs;
    [
      # cli tools
      _1password-cli
      fd
      ffmpeg
      fzf
      jq
      pv
      ripgrep
      tree
      unzip
      wget
      neofetch
      tmux

      # dev
      direnv
      entr
      git
      nixfmt-rfc-style
      python3
    ]
    ++ lib.optionals (!isDarwin) [
      # Linux-specific cli tools
      acpi
      dig
      imagemagick
      pciutils
      playerctl
      stow
      sysstat
      wireguard-tools
      xclip
      zsh
      docker-compose
      tcpdump

      # Linux tui
      gotop
      htop
      nix-tree
    ]
    ++ lib.optionals isDarwin [
      # Darwin-specific packages
      colima
      docker
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

  # Linux-specific virtualisation
  virtualisation.docker.enable = lib.mkIf (!isDarwin) true;
}
