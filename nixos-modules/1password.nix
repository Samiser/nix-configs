{config, ...}: {
  programs._1password.enable = true;
  programs._1password-gui.enable = config.hostConfig.gui.enable;
}
