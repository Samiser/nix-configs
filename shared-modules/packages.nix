let
  base =
    { pkgs }:
    with pkgs;
    [
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
    ];

  dev =
    { pkgs }:
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
    ];

  desktop =
    { pkgs }:
    with pkgs;
    [
      ffmpeg
      imagemagick
      fastfetch
      pandoc
    ];

  fonts =
    { pkgs }:
    with pkgs;
    [
      nerd-fonts.jetbrains-mono
    ];

  all =
    { pkgs }:
    (base { inherit pkgs; }) ++ (dev { inherit pkgs; }) ++ (desktop { inherit pkgs; });
in
{
  inherit
    base
    dev
    desktop
    fonts
    all
    ;
}
