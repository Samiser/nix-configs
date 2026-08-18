{ config, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./boot.nix
    ./nvidia.nix
    ./audio.nix
    ./tailscale.nix
    ./noctalia-greeter.nix
  ];

  host.profile = {
    desktop = true;
    dev = true;
  };

  hostConfig.hyprland = {
    enable = true;
    tuigreet = false;
  };

  services.displayManager.noctalia-greeter = {
    enable = true;
    settings.keyboard.layout = "us";
  };

  services = {
    openssh.enable = true;
    closured.enable = true;

    nix-update = {
      enable = true;
      githubUser = "samiser";
      gitAuthor = {
        name = "Samiser";
        email = "github@me.samiser.xyz";
      };
      tokenFile = config.age.secrets.nixpkgs-update-token.path;
      packages = [
        { name = "hyprmag"; }
        { name = "noctalia-greeter"; }
        {
          name = "noctalia";
          versionPreference = "unstable";
        }
      ];
      createPullRequests = false;
    };
  };

  networking.hostName = "yidhra";

  system.stateVersion = "26.05";
}
