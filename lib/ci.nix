{
  inputs,
  nixosConfigurations,
  darwinConfigurations,
  devShells,
}: let
  inherit (inputs) nix-github-actions;

  prefixAttrs = prefix: attrs:
    builtins.listToAttrs (builtins.map (name: {
      name = "${prefix} ${name}";
      value = attrs.${name};
    }) (builtins.attrNames attrs));

  groupBySystem = prefix: configs: let
    entries = builtins.map (name: let
      drv = configs.${name}.config.system.build.toplevel;
    in {
      inherit (drv) system;
      name = "${prefix} ${name}";
      value = drv;
    }) (builtins.attrNames configs);
  in
    builtins.foldl' (
      acc: entry:
        acc
        // {
          ${entry.system} =
            (acc.${entry.system} or {})
            // {
              ${entry.name} = entry.value;
            };
        }
    ) {}
    entries;

  hostChecks =
    groupBySystem "nixosConfig" nixosConfigurations
    // groupBySystem "darwinConfig" darwinConfigurations;

  shellChecks = builtins.mapAttrs (_: prefixAttrs "devShell") devShells;

  allSystems = builtins.attrNames (hostChecks // shellChecks);
  checks = builtins.listToAttrs (builtins.map (system: {
      name = system;
      value = (hostChecks.${system} or {}) // (shellChecks.${system} or {});
    })
    allSystems);
in {
  inherit checks;
  githubActions = nix-github-actions.lib.mkGithubMatrix {inherit checks;};
}
