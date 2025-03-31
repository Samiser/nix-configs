{ lib, config, pkgs, ... }:

with lib;
with types; {
  imports = [ ./config.nix ./tailscale.nix ./openssh.nix ];

  services = {
    xserver = {
      enable = true;
      autorun = true;

      videoDrivers = [ "modesetting" ];

      libinput.enable = true;

      layout = "gb";

      displayManager = {
        lightdm.greeter.enable = false;
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
}
