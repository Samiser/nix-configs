{
  lib,
  config,
  pkgs,
  my-neovim,
  ...
}:
let
  cfg = config.sam.neovim;
in
{
  options.sam.neovim = {
    minimal = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the minimal Neovim configuration.";
    };
    enable = lib.mkEnableOption "Enable Neovim integration.";
  };

  config = lib.mkIf cfg.enable {
    home.packages =
      if cfg.minimal then
        [ my-neovim.packages."${pkgs.stdenv.hostPlatform.system}".minimal ]
      else
        [ my-neovim.packages."${pkgs.stdenv.hostPlatform.system}".default ];
  };
}
