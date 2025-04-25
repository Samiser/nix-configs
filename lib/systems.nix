{inputs}: let
  inherit (inputs) nixpkgs nix-darwin;

  systemTypes = {
    darwin = {
      defaultSystem = "aarch64-darwin";
      builder = nix-darwin.lib.darwinSystem;
      configFile = "darwin-configuration.nix";
    };
    nixos = {
      defaultSystem = "x86_64-linux";
      builder = nixpkgs.lib.nixosSystem;
      configFile = "configuration.nix";
    };
  };

  mkSystem = hostname: systemType: let
    inherit (systemType) defaultSystem builder configFile;
    systemPath = ../hosts/${hostname}/system.nix;
  in
    builder {
      system =
        if builtins.pathExists systemPath
        then (import ../hosts/${hostname}/system.nix).system
        else defaultSystem;
      specialArgs = inputs;
      modules = [
        ../hosts/${hostname}/${configFile}
      ];
    };

  hostsDir = ../hosts;
  hosts = builtins.attrNames (builtins.readDir hostsDir);

  getSystemType = hostPath: let
    files = builtins.attrNames (builtins.readDir hostPath);
  in
    if builtins.elem "configuration.nix" files
    then "nixos"
    else if builtins.elem "darwin-configuration.nix" files
    then "darwin"
    else null;

  configurations = let
    allConfigs =
      builtins.map (
        hostname: let
          systemType = getSystemType "${hostsDir}/${hostname}";
        in {
          inherit systemType;
          name = "${hostname}";
          value = mkSystem hostname systemTypes."${systemType}";
        }
      )
      hosts;

    filterConfigs = type:
      builtins.listToAttrs
      (builtins.filter (config: config.systemType == type) allConfigs);
  in {
    nixosConfigurations = filterConfigs "nixos";
    darwinConfigurations = filterConfigs "darwin";
  };
in {
  __functor = _: _: configurations;
}
