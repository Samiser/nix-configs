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
      defaultSystem = "aarch64-darwin";
      builder = nix-darwin.lib.darwinSystem;
      configFile = "darwin-configuration.nix";
      commonModules = modules.darwin;
    };
    nixos = {
      defaultSystem = "x86_64-linux";
      builder = nixpkgs.lib.nixosSystem;
      configFile = "configuration.nix";
      commonModules = modules.nixos;
    };
  };

  getSystemType =
    hostPath:
    let
      files = builtins.attrNames (builtins.readDir hostPath);
    in
    if builtins.elem "configuration.nix" files then
      "nixos"
    else if builtins.elem "darwin-configuration.nix" files then
      "darwin"
    else
      null;

  hostSystem =
    hostname: systemType:
    if builtins.pathExists ../hosts/${hostname}/system.nix then
      (import ../hosts/${hostname}/system.nix).system
    else
      systemType.defaultSystem;

  mkSystem =
    hostname: systemType:
    let
      inherit (systemType) builder configFile commonModules;
    in
    builder {
      system = hostSystem hostname systemType;
      specialArgs = inputs;
      modules = commonModules ++ [
        ../hosts/${hostname}/${configFile}
      ];
    };

  allConfigs = builtins.map (
    hostname:
    let
      systemType = getSystemType "${hostsDir}/${hostname}";
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
      value = hostSystem hostname systemTypes.${getSystemType "${hostsDir}/${hostname}"};
    }) hosts
  );
in
{
  nixosConfigurations = filterConfigs "nixos";
  darwinConfigurations = filterConfigs "darwin";
  inherit hostSystems;
}
