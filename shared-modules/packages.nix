{
  config,
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages =
    (with pkgs; [
      dig
      fd
      fzf
      gotop
      htop
      jq
      pv
      ripgrep
      tmux
      tree
      unzip
      wget
    ])
    ++ lib.optionals config.host.profile.dev (
      with pkgs;
      [
        claude-code
        direnv
        docker-compose
        entr
        gh
        git
        nixfmt
        nixpkgs-review
        nix-tree
        nix-update
        python3
      ]
    )
    ++ lib.optionals config.host.profile.desktop (
      with pkgs;
      [
        ffmpeg
        imagemagick
        fastfetch
        godot
        pandoc
      ]
    );

  fonts.packages = lib.mkIf config.host.profile.desktop [ pkgs.nerd-fonts.jetbrains-mono ];
}
