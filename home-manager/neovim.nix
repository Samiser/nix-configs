{
  lib,
  config,
  pkgs,
  my-neovim,
  ...
}:
with lib; let
  cfg = config.sam.neovim;
in {
  options.sam.neovim = {
    minimal = mkOption {
      type = types.bool;
      default = false;
      description = "Enable the minimal Neovim configuration.";
    };
    enable = mkEnableOption "Enable Neovim integration.";
  };

  config = mkIf cfg.enable {
    home.packages =
      if cfg.minimal
      then [my-neovim.packages."${pkgs.system}".minimal]
      else [my-neovim.packages."${pkgs.system}".default];
  };
}
