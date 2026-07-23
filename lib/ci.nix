{
  nixosConfigurations,
  darwinConfigurations,
  devShells,
  hostSystems,
}:
let
  prefixAttrs =
    prefix: attrs:
    builtins.listToAttrs (
      builtins.map (name: {
        name = "${prefix} ${name}";
        value = attrs.${name};
      }) (builtins.attrNames attrs)
    );

  groupBySystem =
    prefix: configs:
    let
      entries = builtins.map (name: {
        system = hostSystems.${name};
        name = "${prefix} ${name}";
        value = configs.${name}.config.system.build.toplevel;
      }) (builtins.attrNames configs);
    in
    builtins.foldl' (
      acc: entry:
      acc
      // {
        ${entry.system} = (acc.${entry.system} or { }) // {
          ${entry.name} = entry.value;
        };
      }
    ) { } entries;

  hostChecks =
    groupBySystem "nixosConfig" nixosConfigurations
    // groupBySystem "darwinConfig" darwinConfigurations;

  shellChecks = builtins.mapAttrs (_: prefixAttrs "devShell") devShells;

  allSystems = builtins.attrNames (hostChecks // shellChecks);
  checks = builtins.listToAttrs (
    builtins.map (system: {
      name = system;
      value = (hostChecks.${system} or { }) // (shellChecks.${system} or { });
    }) allSystems
  );
  ciMatrix = builtins.concatMap (
    system: builtins.map (name: { inherit name system; }) (builtins.attrNames checks.${system})
  ) (builtins.attrNames checks);
in
{
  inherit checks ciMatrix;
}
