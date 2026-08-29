{
  inputs,
  nixosConfigurations,
}:
let
  inherit (inputs) deploy-rs;
  inherit (inputs.nixpkgs) lib;

  mkDeployNode = _: nixosConfig: {
    hostname = nixosConfig.config.networking.hostName;
    profiles.system = {
      sshUser = "root";
      path = deploy-rs.lib.x86_64-linux.activate.nixos nixosConfig;
    };
  };
in
{
  deploy.nodes = lib.mapAttrs mkDeployNode (
    lib.filterAttrs (_: config: config.config.host.deploy.enable) nixosConfigurations
  );
}
