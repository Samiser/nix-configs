{
  lib,
  config,
  ...
}: {
  services = lib.mkIf config.hostConfig.gui.enable {
    pipewire = {
      enable = true;
      pulse.enable = true;
    };
  };
}
