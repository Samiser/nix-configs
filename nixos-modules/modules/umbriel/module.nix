# Vendored from https://github.com/NixOS/nixpkgs/pull/555208.
# Kept the same apart from wayland-session.nix which is brought in via modulesPath.
{
  config,
  lib,
  modulesPath,
  pkgs,
  ...
}:
let
  cfg = config.programs.umbriel;
in
{
  options.programs.umbriel = {
    enable = lib.mkEnableOption "Umbriel, a Wayland compositor built on wlroots and SceneFX";
    package = lib.mkPackageOption pkgs "umbriel" { };
    portalPackage = lib.mkPackageOption pkgs "xdg-desktop-portal-umbriel" { };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        environment.systemPackages = [ cfg.package ];
        services.displayManager.sessionPackages = [ cfg.package ];
        systemd.packages = [ cfg.package ];

        systemd.user.services.umbriel = {
          restartIfChanged = false;
          enableDefaultPath = false;
        };

        xdg.portal = {
          enable = lib.mkDefault true;
          extraPortals = [ cfg.portalPackage ];
          configPackages = [ cfg.portalPackage ];
        };
      }

      (import "${modulesPath}/programs/wayland/wayland-session.nix" {
        inherit lib pkgs;
        enableXWayland = false;
        enableWlrPortal = false;
      })
    ]
  );

  meta.maintainers = with lib.maintainers; [
    samiser
    pyrox0
  ];
}
