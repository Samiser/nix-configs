{ lib, config, pkgs, ... }:

with lib;
with types; {
  imports = [ ./config.nix ];

  services = {
    xserver = {
      enable = true;
      autorun = true;

      videoDrivers = [ "modesetting" ];

      libinput.enable = true;

      layout = "gb";

      displayManager = {
        lightdm.enable = true;
        autoLogin.enable = true;
        autoLogin.user = config.hostConfig.autologin.user;
        defaultSession = config.hostConfig.autologin.session;
      };

      monitorSection = ''
        DisplaySize 508 286
      '';
    };
  };

  services.printing.enable = true;

  services.openssh.enable = true;

  services.tailscale.enable = true;
}
