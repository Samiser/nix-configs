{ nixosConfig, ... }:

{
  imports = [ ./zsh ./git ./alacritty ./neovim ./pywal ./i3 ];

  # home.stateVersion = nixosConfig.system.stateVersion;
  home.stateVersion = "23.05";
}
