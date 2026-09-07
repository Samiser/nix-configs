{ pkgs, osConfig, ... }:
{
  home.packages = [
    (if osConfig.host.profile.server then pkgs.my-neovim-minimal else pkgs.my-neovim)
  ];
}
