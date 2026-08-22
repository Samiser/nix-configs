{
  config,
  lib,
  pkgs,
  ...
}:
let
  compositorEnabled =
    config.hostConfig.hyprland.enable
    || config.hostConfig.mango.enable
    || config.hostConfig.umbriel.enable;
in
{
  config = lib.mkIf compositorEnabled {
    programs.noctalia.enable = true;

    services.displayManager.noctalia-greeter.enable = true;

    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    nixpkgs.overlays = [
      (_final: prev: {
        wl-kbptr = prev.wl-kbptr.overrideAttrs (old: {
          patches = (old.patches or [ ]) ++ [ ./wl-kbptr-pixman-stride.patch ];
        });
      })
    ];

    environment.systemPackages = with pkgs; [
      grim
      slurp
      wl-clipboard
      wl-kbptr
    ];
  };
}
