{ lib, config, nixosConfig, pkgs, ... }:

with lib;

let cfg = config.sam.pywal;
in {
  options.sam.pywal.enable = mkEnableOption "pywal config";

  config = mkIf cfg.enable { programs.pywal.enable = true; };
}
