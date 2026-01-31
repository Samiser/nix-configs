{
  pkgs,
  keys,
  agenix,
  ...
}: {
  environment.systemPackages = with pkgs; [
    agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
    dig
    direnv
    fd
    fzf
    git
    htop
    jq
    pciutils
    ripgrep
    sysstat
    tcpdump
    tmux
    tree
    unzip
    wget
    wireguard-tools
    zsh
  ];

  services = {
    openssh.enable = true;
    tailscale.enable = true;
  };

  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  nixpkgs.config.allowUnfree = true;

  users.mutableUsers = false;
  programs.zsh.enable = true;

  users.users.sam = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "video" "libvirtd" "docker"];
    shell = pkgs.zsh;
    hashedPassword = "$6$YvQ.LsWTIYp2jkWe$brA.AICuG4BEvRBchrVmrHwe.6Mr6RgfTcwHBTXTmhjqgVP9Ql5vktY/zPWJc5Y3aEp5EYkFO0fpP/RnUU0dH0";
    openssh.authorizedKeys.keys = [keys.sam];
  };
}
