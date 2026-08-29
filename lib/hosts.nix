{
  inputs,
  modules,
}:
let
  inherit (inputs) nixpkgs nix-darwin;

  hostsDir = ../hosts;
  hosts = builtins.attrNames (builtins.readDir hostsDir);

  systemTypes = {
    darwin = {
      system = "aarch64-darwin";
      builder = nix-darwin.lib.darwinSystem;
      configFile = "darwin-configuration.nix";
      commonModules = modules.darwin;
    };
    nixos = {
      system = "x86_64-linux";
      builder = nixpkgs.lib.nixosSystem;
      configFile = "configuration.nix";
      commonModules = modules.nixos;
    };
  };

  getSystemType =
    hostname:
    let
      files = builtins.attrNames (builtins.readDir "${hostsDir}/${hostname}");
    in
    if builtins.elem "configuration.nix" files then
      "nixos"
    else if builtins.elem "darwin-configuration.nix" files then
      "darwin"
    else
      throw "hosts/${hostname} has neither configuration.nix nor darwin-configuration.nix";

  mkSystem =
    hostname:
    {
      system,
      builder,
      configFile,
      commonModules,
    }:
    builder {
      inherit system;
      specialArgs = inputs;
      modules = commonModules ++ [
        ../hosts/${hostname}/${configFile}
        { _module.args = { inherit serverHostNames; }; }
      ];
    };

  serverHostNames = builtins.attrNames (
    nixpkgs.lib.filterAttrs (_: c: c.config.host.profile.server) (filterConfigs "nixos")
  );

  allConfigs = builtins.map (
    hostname:
    let
      systemType = getSystemType hostname;
    in
    {
      inherit systemType;
      name = hostname;
      value = mkSystem hostname systemTypes.${systemType};
    }
  ) hosts;

  filterConfigs =
    type: builtins.listToAttrs (builtins.filter (config: config.systemType == type) allConfigs);

  hostSystems = builtins.listToAttrs (
    builtins.map (hostname: {
      name = hostname;
      value = systemTypes.${getSystemType hostname}.system;
    }) hosts
  );
in
{
  nixosConfigurations = filterConfigs "nixos";
  darwinConfigurations = filterConfigs "darwin";
  inherit hostSystems;
}
