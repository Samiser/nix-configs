{lib, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./nvidia-optimus.nix
    ./bluetooth.nix
  ];

  host.profile = {
    desktop = true;
    dev = true;
  };

  hostConfig.i3.enable = true;

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  systemd.services = {
    NetworkManager-wait-online.enable = lib.mkForce false;
    systemd-networkd-wait-online.enable = lib.mkForce false;
  };

  networking = {
    hostName = "imperium";
    interfaces.wlp59s0.useDHCP = true;
    networkmanager.enable = true;
  };

  services = {
    libinput.enable = true;
    ntp.enable = true;

    xserver = {
      videoDrivers = ["modesetting"];
      monitorSection = ''
        DisplaySize 508 286
      '';
    };
  };

  console = {
    font = "latarcyrheb-sun32";
    keyMap = "uk";
  };

  i18n.defaultLocale = "en_GB.UTF-8";
  time.timeZone = "Europe/London";

  security.pam = {
    sshAgentAuth.enable = true;
    services.sudo.sshAgentAuth = true;
  };

  programs.ssh.startAgent = true;

  system.stateVersion = "21.05";
}
