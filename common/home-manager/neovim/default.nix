{ lib, config, nixosConfig, pkgs, ... }:

with lib;

let cfg = config.sam.neovim;
in {
  options.sam.neovim.enable = mkEnableOption "neovim config";

  config = mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      plugins = with pkgs.vimPlugins; [
        supertab
        bufferline-nvim
        nvim-web-devicons

        # rust
        nvim-lspconfig
        rust-tools-nvim
        nvim-cmp
        cmp-nvim-lsp
        cmp_luasnip
        cmp-buffer
        luasnip
      ];
      extraConfig = (builtins.readFile ./init.vim);
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
    };
  };
}
