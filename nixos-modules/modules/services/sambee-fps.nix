{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.sambee-fps;
  pck = "/var/lib/sambee/SambeeFPS.pck";
  # ENet (UDP) listen port, from Networking/network_manager.gd.
  port = 8910;
in
{
  options.services.sambee-fps = {
    enable = lib.mkEnableOption "Sambee FPS dedicated Godot server";
  };

  config = lib.mkIf cfg.enable {
    systemd.services.sambee-fps = {
      description = "Sambee FPS dedicated server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      # Only start once a build has been deployed to the shared directory.
      unitConfig.ConditionPathExists = pck;
      serviceConfig = {
        DynamicUser = true;
        StateDirectory = "sambee-server";
        Environment = "HOME=/var/lib/sambee-server";
        ExecStart = "${pkgs.godot}/bin/godot --headless --main-pack ${pck} --server";
        Restart = "on-failure";
        RestartSec = 3;
      };
    };

    # Godot clients reach the dedicated server over ENet/UDP.
    networking.firewall.allowedUDPPorts = [ port ];

    # polkit must be enabled for the rule below to be consulted at all.
    security.polkit.enable = true;

    # Let the CI runner restart the server after deploying a new build.
    security.polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (action.id == "org.freedesktop.systemd1.manage-units" &&
            action.lookup("unit") == "sambee-fps.service" &&
            subject.user == "sambee-runner") {
          return polkit.Result.YES;
        }
      });
    '';
  };
}
