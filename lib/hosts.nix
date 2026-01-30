{
  inputs,
  modules,
}: let
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

  getSystemType = hostPath: let
    files = builtins.attrNames (builtins.readDir hostPath);
  in
    if builtins.elem "configuration.nix" files
    then "nixos"
    else if builtins.elem "darwin-configuration.nix" files
    then "darwin"
    else null;

  mkSystem = hostname: systemType: let
    inherit (systemType) defaultSystem builder configFile commonModules;
    systemPath = ../hosts/${hostname}/system.nix;
  in
    builder {
      system =
        if builtins.pathExists systemPath
        then (import ../hosts/${hostname}/system.nix).system
        else defaultSystem;
      specialArgs = inputs;
      modules =
        commonModules
        ++ [
          ../hosts/${hostname}/${configFile}
        ];
    };

  allConfigs =
    builtins.map (
      hostname: let
        systemType = getSystemType "${hostsDir}/${hostname}";
      in {
        inherit systemType;
        name = hostname;
        value = mkSystem hostname systemTypes.${systemType};
      }
    )
    hosts;

  filterConfigs = type:
    builtins.listToAttrs
    (builtins.filter (config: config.systemType == type) allConfigs);
in {
  nixosConfigurations = filterConfigs "nixos";
  darwinConfigurations = filterConfigs "darwin";
}
