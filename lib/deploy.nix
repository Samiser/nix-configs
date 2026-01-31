{
  inputs,
  nixosConfigurations,
}: let
  inherit (inputs) deploy-rs;

  hosts = builtins.attrNames nixosConfigurations;

  mkDeployNode = nixosConfig: {
    hostname = nixosConfig.config.networking.hostName;
    profiles.system = {
      sshUser = "root";
      path = deploy-rs.lib.x86_64-linux.activate.nixos nixosConfig;
    };
  };

  deployNodes =
    builtins.listToAttrs
    (builtins.filter (x: x != null)
      (builtins.map (
          hostname: let
            nixosConfig = nixosConfigurations.${hostname};
          in
            if nixosConfig.config.host.deploy.enable
            then {
              name = hostname;
              value = mkDeployNode nixosConfig;
            }
            else null
        )
        hosts));
in {
  deploy.nodes = deployNodes;
}
