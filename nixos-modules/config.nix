{lib, ...}:
with lib; {
  options.hostConfig = {
    gui.enable = mkEnableOption "GUI programs";
    vm = mkOption {
      type = types.bool;
      default = false;
    };
  };
}
