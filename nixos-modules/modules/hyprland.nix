{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.hostConfig.hyprland;
in
{
  options.hostConfig.hyprland = {
    enable = lib.mkEnableOption "Hyprland Wayland compositor";

    tuigreet = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Use tuigreet as the greetd greeter.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.hyprland.enable = true;
    programs.noctalia.enable = true;

    services.greetd = lib.mkIf cfg.tuigreet {
      enable = true;
      settings.default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-user-session --asterisks --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions";
        user = "greeter";
      };
    };

    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    environment.systemPackages = with pkgs; [
      grim
      slurp
      wl-clipboard
    ];
  };
}
