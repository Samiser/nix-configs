{lib, ...}: {
  options.hostConfig = {
    gui.enable = lib.mkEnableOption "GUI programs";
  };
}
