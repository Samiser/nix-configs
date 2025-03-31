{lib, ...}:
with lib; {
  options.hostConfig = {
    gui.enable = mkEnableOption "enable GUI programs";
  };
}
