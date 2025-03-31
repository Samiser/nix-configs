{lib, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../../nixos-modules
  ];

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

  # Console settings
  console = {
    font = "latarcyrheb-sun32";
    keyMap = "uk";
  };

  i18n.defaultLocale = "en_GB.UTF-8";
  time.timeZone = "Europe/London";
  services.ntp.enable = true;

  # Custom host config
  hostConfig = {
    gui.enable = true;
    i3.enable = true;
    autologin = {
      user = "sam";
      session = "none+i3";
    };
  };

  security.pam.enableSSHAgentAuth = true;
  security.pam.services.sudo.sshAgentAuth = true;
  programs.ssh.startAgent = true;

  system.stateVersion = "21.05";
}
