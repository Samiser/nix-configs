{lib, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../../nixos-modules/modules
    ../../nixos-modules/profiles/base.nix
    ../../nixos-modules/profiles/desktop.nix
    ../../nixos-modules/profiles/pkgs.nix
    ../../nixos-modules/hardware/bluetooth.nix
    ../../nixos-modules/hardware/nvidia-optimus.nix
  ];

  hostConfig.i3.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
  systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;

  # Configure wifi interface
  networking = {
    hostName = "imperium";
    interfaces.wlp59s0.useDHCP = true;
    networkmanager.enable = true;
  };

  services = {
    libinput.enable = true;

    xserver = {
      videoDrivers = ["modesetting"];
      monitorSection = ''
        DisplaySize 508 286
      '';
    };
  };

  # Console settings
  console = {
    font = "latarcyrheb-sun32";
    keyMap = "uk";
  };

  i18n.defaultLocale = "en_GB.UTF-8";
  time.timeZone = "Europe/London";
  services.ntp.enable = true;

  security.pam.sshAgentAuth.enable = true;
  security.pam.services.sudo.sshAgentAuth = true;
  programs.ssh.startAgent = true;

  system.stateVersion = "21.05";
}
